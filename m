Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4C254D39A
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 23:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349623AbiFOVX7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 17:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349580AbiFOVX7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 17:23:59 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038DD554B8
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 14:23:58 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id z14so7554799pjb.4
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 14:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=yoThJeOXn2CUCw7hvunOwpcNtuH0GBr04LNnNbR5Eyc=;
        b=Rg1FLv46lVLFZVAp3NQ7/HOSefmTZse4dXbrLDsGj3BhOL47S5G7myUNWg1OOs+R2s
         CxOKGUl36hV0XGNH2nj6o3OkHf9hmTOtDd9KmSeAocC1KIyXBgdQfaqT6/TM1tO0Ekgo
         lMdAiqff3v8sihEGHgilKTU8B7zgxt8hIgD9pYRqpW6wcaiIOCTHj9rjTKrwznvkW4U6
         8RTtCLHQ+nUbhXX6n+UjGbQlTc1qs/R5gJniSbMoyhLPA+9/Q5Hsxg3FwPJDKANaT9NV
         Cn7vQ20aUnwArGKvmHzLjlBMtb6RY/+bGm4flfHyF6mQqywzqD3HBlplgMVLjOAosF7S
         kI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=yoThJeOXn2CUCw7hvunOwpcNtuH0GBr04LNnNbR5Eyc=;
        b=NyfX1/bwjOBirHGB310SVUX4LAFe/lHiM/WLF+QuhzJZt0T6HcW6oqqslBhBVTXqaE
         oj1hYwujOJuA/vM0jBfeDJncod5LIDjOzCaRJxwJ/ChiIkCvUw4GQGtPP4EZMjUc7jBb
         lhYflFZTvBSjxiTff2ZDkhDjLizeDIquHu34AAkYH7KyATkAxnyteZXXCFHdY1C0HydK
         pVJovTp/SPAGjMYeSsYnZdepH11XIJLWWM7Js0U6isFZcI3tObVFe3igcd4dLG6OrCrS
         6kDEGDsYeletGifsjByOUpBsV+/QzS4nS3SSTP9D/8U3TivBcdyVqkuOCVKyzaM+GtY+
         HdDg==
X-Gm-Message-State: AJIora9V1Drc2TCP+qqSNQI20VQHV47BCwui95qZKJY/sraFi4X9SKEt
        QqIY7NQwgE3hJMrxYj5mPjNxTlaBG6Co6w==
X-Google-Smtp-Source: AGRyM1voTVF/A6Y5S5FqAQNfJ+BSN+J3efnn5d1bStKd3pzxZueSzKmQTnh7KToi85KUpFQraE3PEA==
X-Received: by 2002:a17:90b:390c:b0:1e2:d499:8899 with SMTP id ob12-20020a17090b390c00b001e2d4998899mr12638488pjb.161.1655328237210;
        Wed, 15 Jun 2022 14:23:57 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jb21-20020a170903259500b0015ed003552fsm58381plb.293.2022.06.15.14.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 14:23:56 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <cover.1655287457.git.asml.silence@gmail.com>
References: <cover.1655287457.git.asml.silence@gmail.com>
Subject: Re: [PATCH 5.19 0/6] CQE32 fixes
Message-Id: <165532823636.852896.7626951550140433327.b4-ty@kernel.dk>
Date:   Wed, 15 Jun 2022 15:23:56 -0600
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

On Wed, 15 Jun 2022 11:23:01 +0100, Pavel Begunkov wrote:
> Several fixes for IORING_SETUP_CQE32
> 
> Pavel Begunkov (6):
>   io_uring: get rid of __io_fill_cqe{32}_req()
>   io_uring: unite fill_cqe and the 32B version
>   io_uring: fill extra big cqe fields from req
>   io_uring: fix ->extra{1,2} misuse
>   io_uring: inline __io_fill_cqe()
>   io_uring: make io_fill_cqe_aux to honour CQE32
> 
> [...]

Applied, thanks!

[1/6] io_uring: get rid of __io_fill_cqe{32}_req()
      (no commit info)
[2/6] io_uring: unite fill_cqe and the 32B version
      (no commit info)
[3/6] io_uring: fill extra big cqe fields from req
      (no commit info)
[4/6] io_uring: fix ->extra{1,2} misuse
      (no commit info)
[5/6] io_uring: inline __io_fill_cqe()
      (no commit info)
[6/6] io_uring: make io_fill_cqe_aux to honour CQE32
      (no commit info)

Best regards,
-- 
Jens Axboe


