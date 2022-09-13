Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379335B6E92
	for <lists+io-uring@lfdr.de>; Tue, 13 Sep 2022 15:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbiIMNrb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Sep 2022 09:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiIMNr3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Sep 2022 09:47:29 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10A846601
        for <io-uring@vger.kernel.org>; Tue, 13 Sep 2022 06:47:27 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id z14-20020a05600c0a0e00b003b486df42a3so4437797wmp.2
        for <io-uring@vger.kernel.org>; Tue, 13 Sep 2022 06:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=Xsk4ckFKWgBNzg5Uz1aVIdS6Q/GiNN7CE/4nenxqTak=;
        b=i1AVRCrOflfLDsskcnbs8IhMN9+cJTec/74dJx4XrIcnTL2yoEdx/+4m4tRdz1fuFE
         02kCHWWrxguSmcZXRBfyY9c4X+ENr0iaeXZCfoa9eMEYVoNjpAIQF7vmAPDxhuMeTv3R
         sefD2oIrwgZPWJNx6H9QpcGj+DapaJPSAgwW3CBJLeMVPAuwhs0Td4pzaLOUClF4Qj0G
         8L9N0n/oV3Sqwbr/EFw6ST2sq2x7cqJxnpi0hKufEEYJ7LtG4wlkSW4g3LhN9Ef2jAEs
         lAFZlxdUtguxK48f5Yoi++5aWU4PN84fmhZjJg6dh8yiM9kHSUAY/RZQP+npWavYg2X/
         HwhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Xsk4ckFKWgBNzg5Uz1aVIdS6Q/GiNN7CE/4nenxqTak=;
        b=kG/eLuVdVMjxa6FY6VHT9u3Ddt5OjlHLXLMpp7AQNE10BIdfHVwpIPvFDdnnVF12Hq
         mxDTl1/IUMS3dicEDP38fI90kD3nSatixRyRVQe/atyAZQF43tyGwTIrKG+1rOiqjVpA
         kvUTQbaMJj/hgXLYhCosYGOPjVn8R+IxkEYDedsBySN/61Xr49NsxfgA5Do3feqvWBNi
         eCsHn9/HlBjF8c/v+EIK3T8ZDND0zHKbUcwuDJbWf8Y+CEcWtapCAI6FT7iLw0sgd/KN
         zg0uQbMGSN8gBerBS5aKFUTnaFb3K7dstJ7ettEwE5hNopUXXPn+2Mz4goSmpd9SJFrv
         06UQ==
X-Gm-Message-State: ACgBeo11EG33FFUpDsAc8IDo+NdZjFjbjVft4IoaV2rNuF1BEH8vzXGJ
        Pabd0+fwCz6OmcNnUZHtW1X4wvmSqxHKIUQz
X-Google-Smtp-Source: AA6agR5qTU6zUSk6wfAd2sk/RO33d2Rrf4NYqKuNJuCO/FS/O96uFPchTdXFyLl7amld8lOaGbXBew==
X-Received: by 2002:a05:600c:3781:b0:3b4:63c8:554b with SMTP id o1-20020a05600c378100b003b463c8554bmr2507792wmr.25.1663076846111;
        Tue, 13 Sep 2022 06:47:26 -0700 (PDT)
Received: from [127.0.0.1] ([185.122.133.20])
        by smtp.gmail.com with ESMTPSA id o28-20020a05600c511c00b003b462b314e7sm14253993wms.16.2022.09.13.06.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 06:47:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>
In-Reply-To: <9754a0970af1861e7865f9014f735c70dc60bf79.1663071587.git.asml.silence@gmail.com>
References: <9754a0970af1861e7865f9014f735c70dc60bf79.1663071587.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/rw: fix error'ed retry return values
Message-Id: <166307684510.3784.2511923201984525328.b4-ty@kernel.dk>
Date:   Tue, 13 Sep 2022 07:47:25 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-95855
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 13 Sep 2022 13:21:23 +0100, Pavel Begunkov wrote:
> Kernel test robot reports that we test negativity of an unsigned in
> io_fixup_rw_res() after a recent change, which masks error codes and
> messes up the return value in case I/O is re-retried and failed with
> an error.
> 
> 

Applied, thanks!

[1/1] io_uring/rw: fix error'ed retry return values
      commit: 62bb0647b14646fa6c9aa25ecdf67ad18f13523c

Best regards,
-- 
Jens Axboe


