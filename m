Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD56230EDD
	for <lists+io-uring@lfdr.de>; Tue, 28 Jul 2020 18:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731162AbgG1QH6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jul 2020 12:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731137AbgG1QH6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jul 2020 12:07:58 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0785C061794
        for <io-uring@vger.kernel.org>; Tue, 28 Jul 2020 09:07:57 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id z17so1544459ill.6
        for <io-uring@vger.kernel.org>; Tue, 28 Jul 2020 09:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Lw00I39tMMHoHHOPSgKttYErvt005RuGUQAb9q20a8A=;
        b=RqPU2X+zvQ6wLFvh+s7um6t3u1YT6mIC+gUFMGecAr8l9AQpAGBbPE/zMhjuYpQ/p4
         IdT6my2n+CRqGOKLTzyki+eNAq+gt7MXHzYwFiNimZy36B2wzN52OeqDlbBY7df6y39z
         nfMQge3leOhTSXjrlnkRshjZ59mSzGD8w6m4xK4/8bY6T9U9zxjrcR4NFc9x8+P1qwZI
         Z4fPRyWypv3vZyTnkX46GllID/yMtR9dKLOwZhm5RJHClfhBgbf+lWujMOXk5nstNTPh
         GSBQ+xTWx6PAMEX1P5h11Mc3VU1YpnJG4i8petmfvBQVL4WxWOMsIyluNHB9yTgFMgy5
         6PfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lw00I39tMMHoHHOPSgKttYErvt005RuGUQAb9q20a8A=;
        b=N5TW+Cfpee+EOqMKhScklqvhVKpS/k4kTFuR9bOIEFc5I20havKJUDAhoj3vGF6VL5
         Gacr04yI3/Bs2ZZ4BQUDtDa5RTu7mPO2Wi23b0NdP1I1lBY92W7TDvfDOHK8FtBCF4IJ
         zo1nwoxM6Ur86cYKp5CqqtnZRNJTifycMHp+s0Utkb7e+pr2UqEmfEfY2z+yMq/WNWVU
         2RUEuduODKvnahQ73Ks8gDPK/ZSU74RDF5KGXyx62dXg8Dksei1F8yWzXnn7sWzRzYts
         mTFwO1APbJJcVjJhqjsMlyh4OQqSDV2+DbPWknUj6YuTLG4btf4UHoSBoGSE1/CKlIgb
         FB8g==
X-Gm-Message-State: AOAM532KLtFri9bA0N/6+QwEkzfyumjqRENQSsZ3SY+CtZDzqlkpaDQH
        NSEeyt2kIseG9GPG6PJUZ0qr2Cp33Cc=
X-Google-Smtp-Source: ABdhPJzp2UcShilNpbtw679mcdc54T2OlM/1D4xB37v6ExdtiSFrRHDtxffOllvt/x8VhSVSJZKS+A==
X-Received: by 2002:a92:50f:: with SMTP id q15mr30550638ile.38.1595952476979;
        Tue, 28 Jul 2020 09:07:56 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p20sm10331001ili.72.2020.07.28.09.07.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 09:07:56 -0700 (PDT)
Subject: Re: [PATCH liburing] .gitignore: add test/nop-all-sizes
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20200728160506.49478-1-sgarzare@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c69c8ce8-e28c-940b-c5e0-90730106935b@kernel.dk>
Date:   Tue, 28 Jul 2020 10:07:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200728160506.49478-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Applied, thanks.

-- 
Jens Axboe

