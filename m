Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0413B0B61
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 19:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbhFVR2e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 13:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbhFVR2d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 13:28:33 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F249AC061756
        for <io-uring@vger.kernel.org>; Tue, 22 Jun 2021 10:26:16 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id s23so152120oiw.9
        for <io-uring@vger.kernel.org>; Tue, 22 Jun 2021 10:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=elxsH/V73yYqCWqS2NOO7QN3MUfSajbvLee8JFsoAJU=;
        b=T1x1ijq1vk3siASE/EC8P3H54tqb3xyzmmDUSheWu+ZavppEtnCtJa/OLb/aUjxhuX
         RUucWnndjb+q5Qfj1Aa1fq0lL0IufARJ4xTwPi82Q/dZih9ZD7U8hvX5gsTorcKlPkH+
         cyfHdvoHaAXsFBAdvH5lp/oeltJb8YtZChuJaqawFg5okXBsAgJyKyZ8YQXB4hHYCs4I
         6mxxDsOb+xidFhp/vMHjsxOu0767gfKPIjyAG/7Jp3ersjAlTWr/n+k2MyZMYB4m/Wgi
         2rVCjm0DKXckv7XJz9FC6YM1okTIuKqeG3F3P5MnBGvFoXYTp7CP9/TxujHCZWL7eRWQ
         KolA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=elxsH/V73yYqCWqS2NOO7QN3MUfSajbvLee8JFsoAJU=;
        b=oTxYT4ios92cW90ItKRTLpDKpKlroD+hrZHwsTOFmCX9Or/AAc2Jq/5R5Y8uF8+gKc
         QViQm41KvlPta8ob0ZBGgYm+pBOA0E02AiuVCh6uwZn6/3HAmytl7SNevgLWi9HlXnN5
         gHp/2I+pbGg/Zq5LRVtS9bo8uOsaQ3boBaQSSbiY3oYFrZz3PIQosmjpOaXa+PDc8KjN
         lgu92gHnF9HdACceAUVWA5w1dkFdE0BkyrWbQCGfSk8AwA4P/GDIWVyAzY7Fs1lxN+K+
         VFkprR8n8Oot/hMoIHFuRfOez+rJgJGubbJIE8+d6bGRDWEp1NZ1Dxb3kf4W5zqCSsBa
         MhoQ==
X-Gm-Message-State: AOAM5315hMUmFzW1YfdKW7kgpnupv58QRu4Vp/AIu6syxROdnYTp5vWw
        n/vESa1oIgU5TrTdAg3aGRELkgcURvxROg==
X-Google-Smtp-Source: ABdhPJxPcWLIgrt0O2t/d4zMfv1dixHInDNRYdmQMZbvCV84iA5lb70N59OqBhK12UxygHoh72fKcg==
X-Received: by 2002:aca:4b13:: with SMTP id y19mr3961380oia.108.1624382776146;
        Tue, 22 Jun 2021 10:26:16 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id o25sm655928ood.20.2021.06.22.10.26.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 10:26:15 -0700 (PDT)
Subject: Re: [PATCH v5 00/10] io_uring: add mkdir, [sym]linkat and mknodat
 support
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <ee7307f5-75f3-60d7-836e-830c701fe0e5@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0441443f-3f90-2d6c-20aa-92dc95a3f733@kernel.dk>
Date:   Tue, 22 Jun 2021 11:26:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ee7307f5-75f3-60d7-836e-830c701fe0e5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/21 5:56 AM, Pavel Begunkov wrote:
> On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
>> This started out as an attempt to add mkdirat support to io_uring which
>> is heavily based on renameat() / unlinkat() support.
>>
>> During the review process more operations were added (linkat, symlinkat,
>> mknodat) mainly to keep things uniform internally (in namei.c), and
>> with things changed in namei.c adding support for these operations to
>> io_uring is trivial, so that was done too. See
>> https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
> 
> io_uring part looks good in general, just small comments. However, I
> believe we should respin it, because there should be build problems
> in the middle.

I can drop it, if Dmitry wants to respin. I do think that we could
easily drop mknodat and not really lose anything there, better to
reserve the op for something a bit more useful.

-- 
Jens Axboe

