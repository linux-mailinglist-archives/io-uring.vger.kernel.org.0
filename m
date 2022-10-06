Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F8D5F685B
	for <lists+io-uring@lfdr.de>; Thu,  6 Oct 2022 15:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiJFNkn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Oct 2022 09:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiJFNkm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Oct 2022 09:40:42 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443F4186DC
        for <io-uring@vger.kernel.org>; Thu,  6 Oct 2022 06:40:41 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q9so1908896pgq.8
        for <io-uring@vger.kernel.org>; Thu, 06 Oct 2022 06:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bcSu1QFLwmhrzfS+oTaI0ABojARg/D5o/+VvYYx4h9A=;
        b=HbyeLZ5pWk1tvq+LNaPUVbvzuThDmnTTua+bjJr4TYDycjvsl8mf6oCAuBkQhMd3gC
         qZ2eHvh65FdGEd2FM7pChnVwEKd1HEsUGFV+vp1+2FBOsqp6J/HdNJKthdD/aiIAEp5a
         J2nQiEq/VJxVNIpZV15axxPWqidR6Wsb588skMDEUpy7uLFdzOXv8dE2fllJ3yHEjQ26
         3/p6QF280tYGq9KY6HVMmiQ6tDKWXb89BGtQ8Tu0/Z1jWf9CH7C7gxQSQ4FpR6jFgMeJ
         bh8W/X9IATW4rH7zNbEmV3hK2ng5SxJsMzLTLUWcz1a08uhFLtbLVOIcP9Mrulmii65c
         zDdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bcSu1QFLwmhrzfS+oTaI0ABojARg/D5o/+VvYYx4h9A=;
        b=TfdRCVXMjCllSRtGW/Bzl9oYjwmZOTkViEFdj+DloEtTltZsHzed8iLvvq3i3y81S2
         1zYb2NjlLFxplhOqJ65jN021Iyfpb90Ko4tmOBGq8mIFmKHMW7pvJotCnSHAfvIQbQxB
         ImDQ3ntD0+o3Q5nfDP8AeOQMQ0jzcoAgrfTfOYvCkWAMtrQF1XqKBKV2TLB+pkBFhGzo
         UdNswPNL2xNZDRQ9gbEYW2tzruVTacHFb1qhps5ChU6Fl4Ms9LVXpU1goest5MFbGkUs
         gksdWTJMSqFA2Gi65Y0FRdiTA6dGTkrLMd9skNCjP0c7KpfDczrbEG+d3hbDCUf03Ni2
         TNEg==
X-Gm-Message-State: ACrzQf3x0Pj0JnOLo8s5927Ac3QT6stnaz9Qk1wOl4VaejgSmhQSS45F
        voBaBBvqwsqFl+jQeFjnhKrGMQ==
X-Google-Smtp-Source: AMsMyM5IfaZndebvuNkrLAWDIbtrXrLGle8JbGNUmnen8fHRYYIJAB8HmRE+UWWMR7oM7JaWFtURcw==
X-Received: by 2002:a65:6bc4:0:b0:439:8ff8:e2e1 with SMTP id e4-20020a656bc4000000b004398ff8e2e1mr4612395pgw.91.1665063640751;
        Thu, 06 Oct 2022 06:40:40 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e5d200b001708c4ebbaesm12080517plf.309.2022.10.06.06.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 06:40:40 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <43983bc8bc507172adda7a0f00cab1aff09fd238.1665018309.git.asml.silence@gmail.com>
References: <43983bc8bc507172adda7a0f00cab1aff09fd238.1665018309.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: optimise mb() in io_req_local_work_add
Message-Id: <166506364006.7863.2864738975982549695.b4-ty@kernel.dk>
Date:   Thu, 06 Oct 2022 07:40:40 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 6 Oct 2022 02:06:10 +0100, Pavel Begunkov wrote:
> io_cqring_wake() needs a barrier for the waitqueue_active() check.
> However, in case of io_req_local_work_add() prior it calls llist_add(),
> which implies an atomic, and with that we can replace smb_mb() with
> smp_mb__after_atomic().
> 
> 

Applied, thanks!

[1/1] io_uring: optimise mb() in io_req_local_work_add
      commit: b4f5d4f4e12def53462ea7f35dafa132f2d54156

Best regards,
-- 
Jens Axboe


