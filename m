Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C522557D65
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 15:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiFWN7N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 09:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiFWN7M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 09:59:12 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACADE3CA40
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:59:11 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id i17so3656238ils.12
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=yroAPqVobPujam4zFSt1OQC2u/BjKl+oRqNnPFkSe6U=;
        b=oMv5/0DIcFAhgFdbeQkH3CKap+nYF+U+kE+muTnqzk9FKf4uTNI7HaV6Di8kNT5ydv
         arz8LqIpQgayPApstQ4Lyyq1Y4K/wiXj9uSvpBTKwvMndVMXODvcHRv0wZ3khkzKijYp
         +F7TzqO2w00Ou8HK3nu+oYd4pfJWgbSxAmSMfy21xO8EphjawwXQsvfEUx5zd6HqYKN0
         nKjJdGKwLV2zv1EIDbOSPiHQOZFhDrFQXlekXbTfyupCxOfCXO2xGHc+fOB86AGguQjb
         UyZ/qc2S/rr9hkP6wf56dV5ZBm1iSQPZdv9oCVHldPXKF/Njm5S3NJ7s4WRWNSyTP4Ug
         CgIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=yroAPqVobPujam4zFSt1OQC2u/BjKl+oRqNnPFkSe6U=;
        b=6TjPuqVEXrsRm8Izdgdto3BFoAE5/Pb9FfVSfxCnTeK9l8La2LJwMyNV9QY40b1X4w
         MXzJKuNjQ1dDp9COoPbzJrxBkEFLZKF4kddQ5dNz2QA80iCrD5EfkqW83IMiBIgT69sg
         CQkYNBSSZ7uk0Vg3FFlzmLwLAgYazQi+y44IS3dm34waebWtcND2t2GJduUXmEI84MiQ
         HzCM286b29FdQrtN0aiM24cS5VCFKo6bXFXZ3bvisORddKly1Blu+zhtficOEHXEFEuP
         OW3oyDWbErmQb0D60Alz3ing5IAVvF4rIlafKWv5SdoMAQ44RDTZBcOvyIEtphvm4M0H
         hZig==
X-Gm-Message-State: AJIora8nP3EZvy3veg72Y/c+g4A0KJWqAcK8mGFToVpjTb38NJamep3K
        6kDRiwDm7YtWTgTNnP9MV3BWb5IaMW7NrQ==
X-Google-Smtp-Source: AGRyM1sD5aZBTiuYJmUviGBK4ZIos9HzoB2nqCvQxAgz7Nam1jEaFNPrVb3TqAE+RuYyEP3uqAJV6Q==
X-Received: by 2002:a05:6e02:ef0:b0:2d9:3367:6ab3 with SMTP id j16-20020a056e020ef000b002d933676ab3mr5087866ilk.251.1655992750832;
        Thu, 23 Jun 2022 06:59:10 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z96-20020a0293e9000000b00339dfa082a7sm1827714jah.109.2022.06.23.06.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 06:59:10 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     hao.xu@linux.dev, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
In-Reply-To: <20220623130126.179232-1-hao.xu@linux.dev>
References: <20220623130126.179232-1-hao.xu@linux.dev>
Subject: Re: [PATCH v2] io_uring: kbuf: inline io_kbuf_recycle_ring()
Message-Id: <165599275016.474038.15971445049016563132.b4-ty@kernel.dk>
Date:   Thu, 23 Jun 2022 07:59:10 -0600
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

On Thu, 23 Jun 2022 21:01:26 +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Make io_kbuf_recycle_ring() inline since it is the fast path of
> provided buffer.
> 
> 

Applied, thanks!

[1/1] io_uring: kbuf: inline io_kbuf_recycle_ring()
      commit: 0c7e8750e623d48fb39f1284fe77299edbdbc2bc

Best regards,
-- 
Jens Axboe


