Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C6E509322
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 00:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382961AbiDTWss (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 18:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382964AbiDTWsr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 18:48:47 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A254827CDC
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 15:46:00 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so6146160pjn.3
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 15:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=yzci1Nf3MUucvbJpqB48YBSQZqjHq/CvPaOHf+bL13M=;
        b=2tnIEjYT0Y9egwtv2NsouWPfGj8CcoZb5w7Ams0zLhDnZPUKiNT+A12v+f+7uXd+NH
         54Q410ELMvHiY42yLI8lgOt7FhC9HIk9J3gb8m484maLyO2kucQdlri0HdQi8q6Sih9+
         r1i+BKgnVI4/yni65+0Osl2SCVC4G5v7QyTPt54LeQt9a5qIemIuImnqYT1PsjuM75bm
         BMuik4yxAqbt/EW58+b0aMEbyyJqJ4PpM5TbUzrrl2x+MZwQEWKG5t6h0VRG7Oe9qmXr
         RwL5GWzM+zvYlSvEgkxuAIh7UBX6odpUbxqwevwCvrtorm4s57BKhk9QFPU8tCH0Mxl9
         Gn/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=yzci1Nf3MUucvbJpqB48YBSQZqjHq/CvPaOHf+bL13M=;
        b=rKbC8k6Ik6ht76BieqO19sdD00cI3/I0950ZjyUnPrALVln/hS9hFpKLKpFGaPN4f1
         d4SFYgjably/pJ0Q97qRrAfMCwUgs8FZrMyWR9YtqLq4L25FdyhlsP09ZxXDeIKkc2yB
         UnQqU1ONnrL5cDW5hMhMINCsiKZMIaY0s+ObbvOJ0agIG39h1LPtmvtz4axPvbgOfUh9
         j79EkfUKpofa4X+/m4WnTZ2cmuBw46DHryAvaRUm4Zcrpr0we6CYfBnTee6XRYG59lTf
         Sy0NVJfg55a83z8WfW2/KgmMPI8Y4cT2OourEDGD6I5F5/xs4MbCDeuY/hzYO7WmTcDA
         114Q==
X-Gm-Message-State: AOAM532TSxMSaoK424Oewbq6f+PVmlfEtrKKQzHo6qK63/dp2RqSmH43
        M2wyfALAjxQxE3wZiVO9l69SCg==
X-Google-Smtp-Source: ABdhPJxDeCGMgmX/Roy6ENG3v3ePcev5TWOTIUyBS9WebQ5coI1ulLKZU2zrJZsoIlk/Bf4dxM9ChA==
X-Received: by 2002:a17:90a:4581:b0:1bc:d215:8722 with SMTP id v1-20020a17090a458100b001bcd2158722mr6846835pjg.149.1650494760123;
        Wed, 20 Apr 2022 15:46:00 -0700 (PDT)
Received: from [127.0.1.1] ([2600:380:4975:46c0:9a40:772a:e789:f8db])
        by smtp.gmail.com with ESMTPSA id t20-20020a63eb14000000b0039e28245722sm20592283pgh.54.2022.04.20.15.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 15:45:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     kernel-team@fb.com, shr@fb.com, io-uring@vger.kernel.org
In-Reply-To: <20220420191524.2906409-1-shr@fb.com>
References: <20220420191524.2906409-1-shr@fb.com>
Subject: Re: [PATCH v2 0/6] liburing: add support for large CQE sizes
Message-Id: <165049475914.553406.15886198699125357825.b4-ty@kernel.dk>
Date:   Wed, 20 Apr 2022 16:45:59 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 20 Apr 2022 12:15:18 -0700, Stefan Roesch wrote:
> This adds support for large CQE sizes in the liburing layer. The large CQE
> sizes double the size compared to the default CQE size.
> 
> To support larger CQE sizes the mmap call needs to be modified to map a larger
> memory region for large CQE's. For default CQE's the size of the mapping stays
> the same.
> Also the ring size calculation needs to change.
> 
> [...]

Applied, thanks!

[1/6] liburing: Update io_uring.h with large CQE kernel changes
      commit: 80222605fa597ee72c3d89f9a7d59c6c24d5153a
[2/6] liburing: increase mmap size for large CQE's
      commit: b2f684deb583070ca0693ba630f98c166f977662
[3/6] liburing: return correct ring size for large CQE's
      commit: b4595bf204f5abbae94449f9f693d26e38bb67c1
[4/6] liburing: index large CQE's correctly
      commit: 5950be3737d71c67c4784bad0fa73801b82cada2
[5/6] liburing: add large CQE tests to nop test
      commit: b0d2bbcb0ed13347a4156000d6a5816247694ffc
[6/6] liburing: Test all configurations with NOP test
      commit: 0281392aa21209a97b7024f4fca26b717ad213c3

Best regards,
-- 
Jens Axboe


