Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C540A66B366
	for <lists+io-uring@lfdr.de>; Sun, 15 Jan 2023 19:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbjAOSS0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Jan 2023 13:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbjAOSSZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Jan 2023 13:18:25 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC2772A5
        for <io-uring@vger.kernel.org>; Sun, 15 Jan 2023 10:18:23 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id z4-20020a17090a170400b00226d331390cso29061059pjd.5
        for <io-uring@vger.kernel.org>; Sun, 15 Jan 2023 10:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bz1PNYF2IkTdxM7wsziJ802lhxaIhKy6Tw9/n6ibIak=;
        b=UsheIb50OetN1t0Cyw8io4p084jSk+BdR9zDVkipc4GgfcPxDzWeawDFaxP/WzcmNV
         f2ac79R9wtmk5+7bDC9v3bKjElvCEh6dk1iE6ukNps4IhmOSHIYZjItuNKQeTuHI/UdM
         aXoktRlPfdTcRjILjDpOcrBjUH25yxvmy8J4Y0Yukd8oNFtTGlXdw7lpueSu0crJKyUb
         DITIyczbr/1TdL2+7gY747MtGgfkG777x/AoQZZc6yD0c9aYQwoQx2s/x0qV6RGOizSr
         +zjXRTLz50ff10KZ0nW1h6PZI5G48ABMj0j0Y+jjmuzCETZbHPPmNGko8pTc9LjN1109
         xr9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bz1PNYF2IkTdxM7wsziJ802lhxaIhKy6Tw9/n6ibIak=;
        b=WpXRctW96Ujcbx3osHZ27zbkS6AHfvdYNppjwVJ6bRQ7c8Izu1KlrrL7yBdznQ41Fw
         82YO+YLccY3VSEF6N8ktZX6y6hji8cDQluYGzWlBttv7p0/SQkGhhfd34whyFhbZVfd4
         FOmTKjuRrn7X1AG/j7FY465+KJJsmktx9Rhrt1/tC4oteZ4bvX8aWRjxk+ALiLjDqDyB
         tiQERNrTSu6buJInWdKY4eKyUem0Uh3VZymmxUqk3kfpIuPcRUypkdnnurnSu1RKmv4c
         fC0TvqCwGOz3M+TAw8+hhNHXLFbSQFVbzD8TTw8mov9EmhmO6Rhi/b3+xdQyv8vtwjV4
         HlYw==
X-Gm-Message-State: AFqh2krBwFxn+zQvUToEhQgF9MCE391DxT4qvQVBIbCAfbJQefSkmigq
        DYrYbMW3IrxHacZ8c5BDP4B95Q==
X-Google-Smtp-Source: AMrXdXtAQvRylpT4NGdTQ+OBVRBy83MRR73p+p+aN082ndX8RWk6Xl+gH0MRGEXOTtlQ+6k/748emw==
X-Received: by 2002:a05:6a20:2d0e:b0:b7:9612:cd31 with SMTP id g14-20020a056a202d0e00b000b79612cd31mr2295065pzl.0.1673806703188;
        Sun, 15 Jan 2023 10:18:23 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j22-20020a63cf16000000b0047899d0d62csm14584257pgg.52.2023.01.15.10.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jan 2023 10:18:22 -0800 (PST)
Message-ID: <34a2449a-8500-4081-dc60-e6e45ecb1680@kernel.dk>
Date:   Sun, 15 Jan 2023 11:18:21 -0700
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHf7xWs1hWvqb61tpBq63CLFvSk=kfAn_nq_2t2gf7O8V9qZ6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/14/23 9:25?PM, Christian Mazakas wrote:
> For some historical context, this feature came about from trying to
> consume liburing from Rust. liburing is such a powerful library and
> it's hard to replace so a dependency on it is reasonable for
> applications wishing to leverage io_uring without developers being
> systems-level experts.
> 
> For languages that can't parse C headers, liburing-ffi saves quite a
> bit of effort in terms of bringing liburing itself to the application
> because it gives consumers a defined set of symbols in the binaries to
> link against.

Oh I know why it was done and why it's there, this is for the
purpose of the README addition. I think it should be a bit more
verbose and explain that.

-- 
Jens Axboe

