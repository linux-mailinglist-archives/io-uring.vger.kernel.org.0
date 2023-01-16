Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB0D66C008
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 14:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjAPNoo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 08:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbjAPNon (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 08:44:43 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033DF1D93A
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 05:44:43 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id jn22so30341270plb.13
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 05:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iBIa3ILNzHP8U+8remnMWr6+41iaH0UTmhdauHdIvtw=;
        b=CyLnG6mQiA9RQ2RPJlRTs9My/nYfzyprsgZnYJzt+4bnLrnWQ0lgmtUE/5cL5Q8GX3
         E8gRX5Pf/eYj2uCRNkYfmR0E0rH1harbnR9AZFJqIRIWbdKKFM4nfH0lfrY55r9mjd3Y
         w94NJcK0dyTFagUoaOFq9Cp2fPev1foYRptU8v/wZX2rKm9zjaSfrBOWHUjCnWyIwP2R
         9vRNhGC0OzOvhSv2aJieLKbii8p/rpVx/RFqqRfS1F89RooujHhQ+Bwt6S0+k6aKWV43
         j0yAogvYBU8YdWfIpqn/tEJhgedusCXh+bYiHTC+IcdFzDBiVa/ELjAhhtsrMlN9Dwns
         D4dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iBIa3ILNzHP8U+8remnMWr6+41iaH0UTmhdauHdIvtw=;
        b=1N7jGHBA0PKZ8vjnIGb/6h/hiQs92VkrmdFzFyIH/kLpT69jg8M2HT8px0F7APTvKY
         xIISO3PxTxsdU9Q1bUzhJstXlpWzsb5Bc1Sl6okJ3FxZ1vqdoARpEf899yOFsciJLOQt
         2LdJhUnKyG6I6z9kW2XesUKFxKeXByM2c3NPFwQfOFulaY7J28YEZ7zLbC4G+sBOU6Pu
         FJeD0CCTuTMro/glkm5fQ+OgL4IsTTXF9H5f6O6DtRGadBXI0bCPhE320mbVt3Kj8WA8
         UtWE6DYhdjDyd65GnVY1JZCxyTeozLs/fz/QKTegimdGDX5cRgbciyWh0u5Thu1VGTQB
         HDaQ==
X-Gm-Message-State: AFqh2kpK8irVfCD9uGplt0wK33QBHwfTyF8+GNB950TMnfeahCD4CGq4
        iCIUeN10XkNHRNn4Gqxoz9B8+A==
X-Google-Smtp-Source: AMrXdXv1LLA7vzZOYVuArlFK3qYvrTkslduaynSwf/RQqRBe2zpZhLPkzlmeY9baYVqf4/6ouz+vgA==
X-Received: by 2002:a05:6a20:4f15:b0:b8:7d48:2843 with SMTP id gi21-20020a056a204f1500b000b87d482843mr940950pzb.6.1673876682413;
        Mon, 16 Jan 2023 05:44:42 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b28-20020aa7951c000000b0056bcb102e7bsm3982707pfp.68.2023.01.16.05.44.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 05:44:41 -0800 (PST)
Message-ID: <61b6a406-a657-28b7-3da7-a2ea817befc6@kernel.dk>
Date:   Mon, 16 Jan 2023 06:44:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC PATCH v1 liburing 2/2] README: Explain about FFI support
Content-Language: en-US
To:     Christian Mazakas <christian.mazakas@gmail.com>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20230114095523.460879-1-ammar.faizi@intel.com>
 <20230114095523.460879-3-ammar.faizi@intel.com>
 <3d217e11-2732-2b85-39c5-1a3e2e3bb50b@kernel.dk>
 <CAHf7xWs1hWvqb61tpBq63CLFvSk=kfAn_nq_2t2gf7O8V9qZ6A@mail.gmail.com>
 <34a2449a-8500-4081-dc60-e6e45ecb1680@kernel.dk>
 <CAHf7xWuX+c1uhPEsq47u9CyqztoGqG4BLwXSen-i15zM1ZFasQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHf7xWuX+c1uhPEsq47u9CyqztoGqG4BLwXSen-i15zM1ZFasQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/15/23 9:18 PM, Christian Mazakas wrote:
> Hmm, how about something more like this:
> 
> +Because liburing's main public interface lives entirely in liburing.h
> as `static inline`
> +functions, users wishing to consume liburing purely as a binary
> dependency should
> +link against liburing-ffi. liburing-ffi contains definitions for
> every `static inline` function
> +in liburing.h.

This is great - Ammar, can you incorporate that when you respin the
patchset?

-- 
Jens Axboe


