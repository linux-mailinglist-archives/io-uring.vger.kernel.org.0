Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D920E56AF00
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 01:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbiGGX2C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jul 2022 19:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236491AbiGGX2B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jul 2022 19:28:01 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD80324BE7
        for <io-uring@vger.kernel.org>; Thu,  7 Jul 2022 16:27:59 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id l124so11705242pfl.8
        for <io-uring@vger.kernel.org>; Thu, 07 Jul 2022 16:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=t6IIOoDo6e8kvKjSOyPfZiSo9RMp/RKIC6F/MTngEso=;
        b=jbUnDUaATkPoiTUMR1OWOkyssdTAdD4a1pD1LU5iAAZD+RvZupS6+eWHyQFKjMpHPL
         n4fSmEnfD8YOjY3Q9gwSM42eb6+zixSHH7kLPE6dqFyQCVaZWADGYbmxLMm5FmxG2DBn
         9D1mh0t+ooHztaJzp6Vt2INWRjdAGHwG6pgy8BtzF2JWxdz61E0zBeYvm3HmeDPufanW
         XcieTO6f3ZV65dQSXcHo7zZh5b6FlmFltlv1jOfeBXCmQFViOBgAZkqugJYfLF54wHOo
         x9tmjiYE6mQPRg3sPAcRV3CW2gzJLt0yX4r/Rna7E5BjOpal32mVREXjZhtgsu6Pr9oo
         OtZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=t6IIOoDo6e8kvKjSOyPfZiSo9RMp/RKIC6F/MTngEso=;
        b=00SkXvyuI5skbKSuOn0+Q4VrTgD2iH4D28nKCJXStrKI5mJ33p4hgPXsXU81Ja4ypA
         C3pVG3l8HnDLDaQDlzIbiYAUo09od3EOuaOfadQOa67NB741J+RQpQ0D9Xxr0nGobHYD
         fKxptr4SeFUa8AbHNrEgsvoOwkVoRcGK8LmAxN+7fVXXoTGlbQKa8rHUujkLhzD+AHoV
         kmYbVvHTIJjYn3TmD254uS7cYfRapKsALzDKTR2Vn2+DRieZQ1xRqS26Lfec4IAW4nny
         2R4B4EoGmj/3VrKLWuKywdovjcxt3N6NMuyCBSG88BL7IOcV/wh5KPzWBFugg41ooNV7
         tpcQ==
X-Gm-Message-State: AJIora9+PysMJsxMc7O0sY9ilwCL6QE5ylhY61aPP3WudGR5o5hEfJBh
        6DX4krVzloa76n5D/vGSSagBpgjuP4PGig==
X-Google-Smtp-Source: AGRyM1vP27j+c8P8qE7ud4L34p8BV2LgiB05HkGlZHyI3PzGueHXFsknLdaYVSlESg04HZIAKX5x4Q==
X-Received: by 2002:a63:1a5c:0:b0:412:96be:cfb with SMTP id a28-20020a631a5c000000b0041296be0cfbmr495135pgm.203.1657236479105;
        Thu, 07 Jul 2022 16:27:59 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p4-20020a625b04000000b005289ffefe82sm4720483pfb.130.2022.07.07.16.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 16:27:58 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <cover.1657203020.git.asml.silence@gmail.com>
References: <cover.1657203020.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/4] poll locking fixes
Message-Id: <165723647842.60895.640587935345175855.b4-ty@kernel.dk>
Date:   Thu, 07 Jul 2022 17:27:58 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 7 Jul 2022 15:13:13 +0100, Pavel Begunkov wrote:
> Fix a stupid bug with recent poll locking optimisations and also add two
> clean ups on top.
> 
> Pavel Begunkov (4):
>   io_uring: don't miss setting REQ_F_DOUBLE_POLL
>   io_uring: don't race double poll setting REQ_F_ASYNC_DATA
>   io_uring: clear REQ_F_HASH_LOCKED on hash removal
>   io_uring: consolidate hash_locked io-wq handling
> 
> [...]

Applied, thanks!

[1/4] io_uring: don't miss setting REQ_F_DOUBLE_POLL
      commit: cac3abc09e660efdf7e5cfc08a1dd036dd469f3c
[2/4] io_uring: don't race double poll setting REQ_F_ASYNC_DATA
      commit: 5667130cabe02a13e1937ccbb4a327ca2b635c47
[3/4] io_uring: clear REQ_F_HASH_LOCKED on hash removal
      commit: 29384959ff90016682457eb2d16c897c02515c51
[4/4] io_uring: consolidate hash_locked io-wq handling
      commit: 7cb765f3b72f4478852dca6cb0e8e04118c89cc2

Best regards,
-- 
Jens Axboe


