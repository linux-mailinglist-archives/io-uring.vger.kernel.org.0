Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F66C5762D5
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 15:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbiGONdk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 09:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234599AbiGONdj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 09:33:39 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E4D3B6
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 06:33:35 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id bf13so4403088pgb.11
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 06:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=r3VZPLjl8PV4dAeMvtnAZOEiyAO+PnOplgekJ7dIu2w=;
        b=LaADw94eXaM3PQuFB3nIVdj/RK6Ih94WjrsXLdzcy40z98PGare9glkeOTlxO0j+zm
         9IFGn2GcBns8MGXgsGKFoiHN5D86UBv4ipW6M4RFhCQj7oYweHuNnKm2dB1qMvSYyyXs
         F/4PZ3rengzPuDIFyfdUSN/v1zka7/xeWoaiDrh3+ouynVgqqyINwPQg/DVa3NLHYu5e
         IyaP7pWGGUfohAe1dIwUPf+Q0A3+z5MYRdg6iwvV6nQqubfxfdh0oxlh0DFYhvfvX8QA
         tk5QyxTc1o8kuMIdMsTBtjYTflvoSwBzkTwfm0xNcTWtWOySne0HxAWNTBrGWvYkR12Y
         ZKMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=r3VZPLjl8PV4dAeMvtnAZOEiyAO+PnOplgekJ7dIu2w=;
        b=Sp+8KL7RZQP3Oh2b+88PsQQU4bL2wkv1XDuVGy+10esHPRr7HoaHBgcxDju3P0IyKM
         qwW0qgjHQfrpGvu5xd3RxlKPc70n4DHz/GFMtGXvGmKNpSSgff7mfA4bxbtz4FmkKHMM
         HsTEtV0Edro4fUst40Hdmmgy999r9k6sn3OFNZOzo+DHF1BeyFbOOhK3XJwKylgbHEOA
         x/Nu1/CB7Za14Dq1Gtjy35UPEPXwNoXtkAQXXe8/ScjocqKXgRLHxLwxzgBMEm47/9j0
         QO2lYCr2XF58Wzqez2fiYlJD3/iODwCbIk67YNZIBi/lLzq5LZg1OvymGapr+joftCav
         GLmg==
X-Gm-Message-State: AJIora9tHO66RCYTCoyP+HeyY6WFpiTNwOp3UcAIVYFNNcb5KqfLpK/n
        mRvXk+PXEsghSfZqAMZgau2Q5w==
X-Google-Smtp-Source: AGRyM1tQo1Hcez2jrp9hAwOhIItJ3TvxtTRkhE+iTH/SfCx2BKRVKJC9ovEHal7OMAGuFGOpS1nThg==
X-Received: by 2002:a05:6a00:234f:b0:525:1f7c:f2bf with SMTP id j15-20020a056a00234f00b005251f7cf2bfmr14147159pfj.14.1657892014520;
        Fri, 15 Jul 2022 06:33:34 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q15-20020a17090a68cf00b001f021cdd73dsm5675930pjj.10.2022.07.15.06.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 06:33:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org, dylany@fb.com
Cc:     sfr@canb.auug.org.au, Kernel-team@fb.com
In-Reply-To: <20220715130252.610639-1-dylany@fb.com>
References: <20220715130252.610639-1-dylany@fb.com>
Subject: Re: [PATCH for-next] io_uring: fix types in io_recvmsg_multishot_overflow
Message-Id: <165789201367.253344.17762458107233426537.b4-ty@kernel.dk>
Date:   Fri, 15 Jul 2022 07:33:33 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 15 Jul 2022 06:02:52 -0700, Dylan Yudaken wrote:
> io_recvmsg_multishot_overflow had incorrect types on non x64 system.
> But also it had an unnecessary INT_MAX check, which could just be done
> by changing the type of the accumulator to int (also simplifying the
> casts).
> 
> 

Applied, thanks!

[1/1] io_uring: fix types in io_recvmsg_multishot_overflow
      commit: 184d0a67566383f4f9e85101e4af495abe86f215

Best regards,
-- 
Jens Axboe


