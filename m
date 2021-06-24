Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4563B251A
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 04:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhFXCja (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 22:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhFXCja (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 22:39:30 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8E8C061574
        for <io-uring@vger.kernel.org>; Wed, 23 Jun 2021 19:37:12 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id r12so6029462ioa.7
        for <io-uring@vger.kernel.org>; Wed, 23 Jun 2021 19:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0nFaYsgzIskLF9dPu/4oXoFkND7u+fRS+UXqKRjlMXU=;
        b=CzuQawpFNl7IDDTxzxuvsFjcQn+Bj0pvdJsHKZg9MMeA3lGRIEz2jIVD4iXr38eeas
         AyMcla7cGvAUGFEIjVGhL81yVKoN1CqEnFp8pQSuvsqcAJEopcN1OBa/IoJHAy9MCCxk
         CbE8DIQIS7Nekdhl/gd+QB6C0OQtl0v289RBXbmuhM1HwZxNJNKKAHL3a5VWg26D+I2p
         ZjTwhCYqynabk6vH7kukbNGEAE4J8c0zmjA+59dW+7gC0WmnGmrvhj/yiopD78HS0aPj
         Ud0VQVFv+pY1hRvvpUj/fel8nSnl8/JTJpDsvuC8G51qDyBue7/7GXfv5uR8OU4o54xI
         LINw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0nFaYsgzIskLF9dPu/4oXoFkND7u+fRS+UXqKRjlMXU=;
        b=jXiqdFgVzUSRdnEHblqKbtNWA7eEBPbywC/EIQkr2st5MOeqIyM3yctYXX++5T3Yka
         hyCkYuNfq3KrXNvJwUxPM1sd9O44gUXmzeVoOWusFCeERtMfFSGjlzAWjx8omI+3sdfY
         FeuMECDxqd0XC5lpmsk1TDKllbNv4ncA2Zp3f+2N+P6b85V3O/t7h86k8klFaIqlRkGI
         c+F2NbH4TicXosw5kFKV8lm40xY1Yvso04ZjstMMRRe9Ew8xi9NPd1fG7lFW4VkyYgFY
         APcbi4TJM+fVFNxQYzt93lCWEELdAsN1AQs3VEzlM5dFS+tDROU0aUTJpYIlRP0S7dMB
         MTjw==
X-Gm-Message-State: AOAM532k5jKOJUy4BEHM8eReGwajsbkqlC2Je9bZ/i1BwE7/sW3F8JX7
        VdCmsbVuFu36TsmYQRxvOvc85+1VEwflfA==
X-Google-Smtp-Source: ABdhPJwas8kEWK8anxL2r87b5o6uNrYBnmeqxsicrSXttVnHXvA16wxqhdYrExWHEMfBn+CnHVYs/Q==
X-Received: by 2002:a02:838c:: with SMTP id z12mr2513885jag.89.1624502231501;
        Wed, 23 Jun 2021 19:37:11 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id t21sm463542ioj.10.2021.06.23.19.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 19:37:10 -0700 (PDT)
Subject: Re: [PATCH v5 00/10] io_uring: add mkdir, [sym]linkat and mknodat
 support
To:     Dmitry Kadashev <dkadashev@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <ee7307f5-75f3-60d7-836e-830c701fe0e5@gmail.com>
 <CAOKbgA71euyOxvzg3PwHxsCFqJ3-hZdC8Ms=TogGLyb-KfLkDQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <767f2429-3227-4051-5151-ab6f6c8a482a@kernel.dk>
Date:   Wed, 23 Jun 2021 20:37:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAOKbgA71euyOxvzg3PwHxsCFqJ3-hZdC8Ms=TogGLyb-KfLkDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/21 11:35 PM, Dmitry Kadashev wrote:
> On Tue, Jun 22, 2021 at 6:56 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
>>> This started out as an attempt to add mkdirat support to io_uring which
>>> is heavily based on renameat() / unlinkat() support.
>>>
>>> During the review process more operations were added (linkat, symlinkat,
>>> mknodat) mainly to keep things uniform internally (in namei.c), and
>>> with things changed in namei.c adding support for these operations to
>>> io_uring is trivial, so that was done too. See
>>> https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
>>
>> io_uring part looks good in general, just small comments. However, I
>> believe we should respin it, because there should be build problems
>> in the middle.
> 
> I knew my celebration was premature! :)

It's all good, just respin with the requested fixes :-)

-- 
Jens Axboe

