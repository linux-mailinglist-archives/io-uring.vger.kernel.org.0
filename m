Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF7D3B0B76
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 19:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbhFVReZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 13:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhFVReY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 13:34:24 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71821C061756
        for <io-uring@vger.kernel.org>; Tue, 22 Jun 2021 10:32:07 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id n99-20020a9d206c0000b029045d4f996e62so3195943ota.4
        for <io-uring@vger.kernel.org>; Tue, 22 Jun 2021 10:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+uSFrNcaOTr98k5e5ObyY3ZoqQ5l61zI7zkYt0LKmF8=;
        b=T95hJNwEqeoFMyY2TF1wShCxrcofsvQDMNY250Dti4bb/5yH9B+1pNpwrzPcW6wfUe
         6KF/kZU+138qNmv7i8hKuOWCZwyaO0g5YQhtJk2ZAAcL7FbPBFLq0j6ty2ErB+i2/SNE
         4nygBtCtOnWVGWL6ADreNwg1pGzkSo5X1ZfPpmfXnV8qtANeaOhPvc+Kom1cPdmn3tDb
         zZabBf4m1776d1e7SupjZX9gw4/ogSqceP18yjZkkjBvZ5J/HhfhqmpBi4lrrZ+NetAU
         VwJHK3irPGESxarj4/bArAIZkHgaTlAyMBEfwxAaP2/D1oCpqdRvwK49yNdG50Q+3YkK
         yR7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+uSFrNcaOTr98k5e5ObyY3ZoqQ5l61zI7zkYt0LKmF8=;
        b=kB4J2SpzodfOMecAnS6jRbYppSVhGPzfp95gdbvRKLVX8C2ZBOWmsq6qpJzJI9H4hz
         j7HwYsp5T/A22ArhUfbkkWMdnLhgwZt2RcHhclsjo85WI+zA1qeWrlx4CS2XumMMxcP6
         Pr7YfVGaQipGdnt0zzqe4o1GX5MR0feVb5BwIYdqb7v5mJBJjqhO88kVGgz2j5EUAFRa
         AA87svRLOF9oVaTfoM2yeLs3XnafE1tsPiTRukBRVDznTQWb/+IQlC7KaFJZF6Yto5Lc
         9oF9/qpzjGWNw7L9R2HFVSlPyD4CnEzQRdMVGhR+BtLF7hqFKU+lojOneJwes+lKvzIo
         h/Sw==
X-Gm-Message-State: AOAM530qNFx4VfZ6XVjqfFA2+AJyvqKevnPKZCWvld3HBgtFyAX52JQc
        iAacI7Jo7tbiKeC8ZuBc9QipBd+kGkp1Dg==
X-Google-Smtp-Source: ABdhPJwcDnVZ1Mcv0dup36rrQfrVv9WoNiJCn7ke1bFECxzi5/08jat9H8ETrN60ajw6+Yru6sqriQ==
X-Received: by 2002:a05:6830:1c2e:: with SMTP id f14mr4065739ote.133.1624383126526;
        Tue, 22 Jun 2021 10:32:06 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id 3sm1678otu.52.2021.06.22.10.32.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 10:32:05 -0700 (PDT)
Subject: Re: [PATCH v5 00/10] io_uring: add mkdir, [sym]linkat and mknodat
 support
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <ee7307f5-75f3-60d7-836e-830c701fe0e5@gmail.com>
 <0441443f-3f90-2d6c-20aa-92dc95a3f733@kernel.dk>
 <b41a9e48-e986-538e-4c21-0e2ad44ccb41@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <53863cb2-8d58-27a1-a6a4-be41f6f5c606@kernel.dk>
Date:   Tue, 22 Jun 2021 11:32:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b41a9e48-e986-538e-4c21-0e2ad44ccb41@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/21 11:28 AM, Pavel Begunkov wrote:
> On 6/22/21 6:26 PM, Jens Axboe wrote:
>> On 6/22/21 5:56 AM, Pavel Begunkov wrote:
>>> On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
>>>> This started out as an attempt to add mkdirat support to io_uring which
>>>> is heavily based on renameat() / unlinkat() support.
>>>>
>>>> During the review process more operations were added (linkat, symlinkat,
>>>> mknodat) mainly to keep things uniform internally (in namei.c), and
>>>> with things changed in namei.c adding support for these operations to
>>>> io_uring is trivial, so that was done too. See
>>>> https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
>>>
>>> io_uring part looks good in general, just small comments. However, I
>>> believe we should respin it, because there should be build problems
>>> in the middle.
>>
>> I can drop it, if Dmitry wants to respin. I do think that we could
>> easily drop mknodat and not really lose anything there, better to
>> reserve the op for something a bit more useful.
> 
> I can try it and send a fold in, if you want.
> Other changes may be on top

Sure that works too, will rebase in any case, and I'd like to add
Christian's ack as well. I'll just re-apply with the fold-ins.

-- 
Jens Axboe

