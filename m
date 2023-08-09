Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68A27764E3
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 18:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjHIQS3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 12:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjHIQSY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 12:18:24 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9E2C3
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 09:18:23 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6873f64a290so1820833b3a.0
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 09:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691597903; x=1692202703;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sHNrp7rQGNgGo7CNhULOafsNdbdIEPTHj+Tp/R4ebmA=;
        b=yv2m0aQ0RB9ltsBo+ESQinPCf5z3oT4PhMbXO6V+Td20rzfsmIJlaiC1lAGpQ8xAm6
         oy9jtCyfnI60ls4Bre/6BAJiXTH3olzaZgCdCeuSsuDJmY9oL2/4ZyALSYluxeC6ZwMx
         qEQyzvjybxCTIZFy3KY/EoYuHi6mQpW1bUKdc9PXa3MHzox5wZ0oMlYKBL7OYgYKmapp
         a75hkZg0FVoAIwwQozRIlyLuYSgnhNanDyFdM8VNT3JsXfLJeBign45OwJR8lIB8qUxV
         Ua5O6wXEsf4mWW7ctDjZLeOJASiU7IDoYeD1vEk5sAhoMEhO2rua5AYddt7c5+R3e96P
         Rc0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691597903; x=1692202703;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sHNrp7rQGNgGo7CNhULOafsNdbdIEPTHj+Tp/R4ebmA=;
        b=IoHi/jfQjVlp8TYQ37OGVs7x38Jn1lO5xZWy1dH8P4Fg9BNIKgcVN2SVw6E3PVdTfX
         FMAyNZpYDCU91lbs5MDIC03QeJln3Ap9AtxRhfgIcYcNRNp88f6q2t2oRU1ZLVFvbcu0
         KP8eiWeVTDPeMlOC9JgfhCPfh8ryHT5bG4tXb9UQfSl2ZP9H8F7hiS6vO/pxHbcQM50t
         1zbw2Bj916DxzYWi8FJE/5YsDSLF9SPsMqtsZecNhDpghZFDgJ2BO0zhVfYwPw3jRiKG
         GCjRbAcbpEVLo2+NIQNHCqBIZKf6ugQCQkC+k6GkDDRTEEmUYu45Dqqu/lGysHWQlnUO
         yaPw==
X-Gm-Message-State: AOJu0YyjtdAU+OuuMQFE8r4gvf2NuYC/JamZVMl5ktAT8RFtr2HX1RY5
        gDkC0st7R0CtrvV+1X6a9tVW9g9pQaO+H+ZkS4o=
X-Google-Smtp-Source: AGHT+IEy5+91TEDVrsYIucZeXbw8p+DZDZbmXmsqUgns91f7Ug4xibVEmVXJ5OMgfano2gwUYs9A7Q==
X-Received: by 2002:a05:6a00:1d23:b0:676:2a5c:7bc5 with SMTP id a35-20020a056a001d2300b006762a5c7bc5mr3428039pfx.1.1691597902931;
        Wed, 09 Aug 2023 09:18:22 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v25-20020a62a519000000b00672ea40b8a9sm10356064pfm.170.2023.08.09.09.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 09:18:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <eeba551e82cad12af30c3220125eb6cb244cc94c.1691594339.git.asml.silence@gmail.com>
References: <eeba551e82cad12af30c3220125eb6cb244cc94c.1691594339.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: break iopolling on signal
Message-Id: <169159790214.59242.16225828896811567195.b4-ty@kernel.dk>
Date:   Wed, 09 Aug 2023 10:18:22 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Wed, 09 Aug 2023 16:20:21 +0100, Pavel Begunkov wrote:
> Don't keep spinning iopoll with a signal set. It'll eventually return
> back, e.g. by virtue of need_resched(), but it's not a nice user
> experience.
> 
> 

Applied, thanks!

[1/1] io_uring: break iopolling on signal
      commit: 7f9a6d082585718f0f053b9cb8c2a94691b45e28

Best regards,
-- 
Jens Axboe



