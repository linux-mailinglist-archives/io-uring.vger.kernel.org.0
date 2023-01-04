Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7965265D85D
	for <lists+io-uring@lfdr.de>; Wed,  4 Jan 2023 17:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239277AbjADQNz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Jan 2023 11:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239899AbjADQNx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Jan 2023 11:13:53 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9D1DEB
        for <io-uring@vger.kernel.org>; Wed,  4 Jan 2023 08:13:52 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id z10so11378763ilq.8
        for <io-uring@vger.kernel.org>; Wed, 04 Jan 2023 08:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k1lkVtg8wvTSaswwkyVEPTudLBUQuySiXJAxigWtHtc=;
        b=E5n+hf/EvyBRQ1X8naPYKgU0PR/pUAR40fpVNhQCZuUPtJgQYpFm+LPRciYuy/V+1X
         P8ICVAFrEMToqocUbyt7CQsP+l10Jf9a9Mum3ExuGfjH9uO2upkzSNTPdlby/8um7Af0
         KVUcTSL6V2+Nc1NXt2PGgtRrGWZ0Vu2S3wMY3v/cRgDpzsHaYMzFD6l9dWExLc4u3A/P
         Zm6qDjnFuKfzIFta4qdByuY08EhqPzCVBtTfQCgbAoKH68EZfncJffAUAgj3L6iQ1qi0
         292CNeBMGSiXsEnGrXvWrrYwk4MZysyDeqYzAup/Qm1FU7OaYNGzkAIY6lS8ijov3BZO
         goNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k1lkVtg8wvTSaswwkyVEPTudLBUQuySiXJAxigWtHtc=;
        b=o7fxMqwnZTzR2gblgJMdPDmcS7cxwERHDhH9eiEb81tXY0ivF3M7VLj/slwNpReHpg
         bWQ+4itlOIuDtJ5TI7MT8O0BeT8XHvODp2ha4FJrRtF9+TSVKlffxshJsc2ewlOUjyw4
         2k/UWOV9Gf6PTJZLL9gA+xiIheDIlTpRENXN6le5eKvT9jTe1jZDcTXdSVnz/N82nnjH
         Do30zlQ/p3WuUuVaVNoqBYpxrYZyIOiw4hKsA3dYIsYupleNY4kfan8qaP3L02G5syaK
         T4w4Jj/M9U+njU6x2AydepkzX52LHAIFC7gzXfjCoOyFuThMB0TxxcnNVUAzKL/rP8jM
         gj1g==
X-Gm-Message-State: AFqh2koYsElzQFIMogvXOaBCYOhJGTWVLPt6yyDFCfdC+AFSpDGYeCZI
        MLMVJmNV7ekGhrOUXsldgIW4Ft6biLVhK9Nv
X-Google-Smtp-Source: AMrXdXtof475JFtcdAy7t2HEvxEZ3viTNEJ4whtnj1wytyp4LC2adCuevrYx1tYqDdXO8BRpIdpOKA==
X-Received: by 2002:a92:d4ce:0:b0:30c:493e:ecf2 with SMTP id o14-20020a92d4ce000000b0030c493eecf2mr1650440ilm.0.1672848831989;
        Wed, 04 Jan 2023 08:13:51 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i17-20020a056638381100b0039d8bcd822fsm11181349jav.166.2023.01.04.08.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 08:13:51 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: =?utf-8?q?=3C1a79362b9c10b8523ef70b061d96523650a23344=2E1672795?=
 =?utf-8?q?998=2Egit=2Easml=2Esilence=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C1a79362b9c10b8523ef70b061d96523650a23344=2E16727959?=
 =?utf-8?q?98=2Egit=2Easml=2Esilence=40gmail=2Ecom=3E?=
Subject: Re: [RFC 1/1] io_uring: pin context while queueing deferred tw
Message-Id: <167284883119.63338.188865590110226329.b4-ty@kernel.dk>
Date:   Wed, 04 Jan 2023 09:13:51 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-7ab1d
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Wed, 04 Jan 2023 01:34:02 +0000, Pavel Begunkov wrote:
> Unlike normal tw, nothing prevents deferred tw to be executed right
> after an tw item added to ->work_llist in io_req_local_work_add(). For
> instance, the waiting task may get waken up by CQ posting or a normal
> tw. Thus we need to pin the ring for the rest of io_req_local_work_add()
> 
> 

Applied, thanks!

[1/1] io_uring: pin context while queueing deferred tw
      (no commit info)

Best regards,
-- 
Jens Axboe


