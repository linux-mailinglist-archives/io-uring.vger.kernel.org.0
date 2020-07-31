Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB71233D81
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 04:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731244AbgGaCxO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 22:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731161AbgGaCxN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 22:53:13 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E768C061575
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 19:53:13 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id q17so16028541pls.9
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 19:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l+uP1W3s0IVnpqxnYvYPs1ilzRwp+d/Px1T0E6Ky5Ck=;
        b=v3IsjUzK4d6pM7yq9hMm7rOU9fqC6NDmZxMWXHhysuQnFv3vTCfwFeIsNDP7cWlwkS
         b3a/UKkZRC0eOy4Rh4/01Ljc9CBJrCkhywpPugYjmHPVqkPrngCACI06EslGsXit3KgG
         k2tNPiLHhGNlLj8TGMYyQk29QW2VMb1avqactPLyPRCGHswWbv4KO1o3nXFCRt7ROVfj
         xUdm1lv9qHTei7A+FP5b5RMHMVe7ryYKTyeRTppajpO6cMp0JT34GpDtEcbLM5dyOYTM
         avuLVIMxEifZ4m+mL9pg2X1OfUWbXksxXjAp1zjwN+M0VLvSvWz5ZFVjs5x3BgaU+BLF
         FbyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l+uP1W3s0IVnpqxnYvYPs1ilzRwp+d/Px1T0E6Ky5Ck=;
        b=LUxYAkp7gxGyeqf+sfm9hSu/HJ8ZXjxD857kSR+chXKgpmL2Klia5ttOxMB1gJh1iV
         sy/UcoPLH6ieTaWBddNk6nGx8GcQNxSJwWuWBPdVQG9XRRfEOsYJYjliVITHARs0QOwX
         o5GTV/X3oiJCN2Gf8G04JsRdG3dh3cPxbM5NbO4Q4AhlnRkcXWWFf85tLYnH1LyCBn0o
         QNLDoniie3IhlDX23aZUFYQfiSEsgLw5CJHxBTfr2r6KYVqjW26y+HD8sGe2DwaiaCF/
         KH9Oe0+Rz3DMyc2RWGAUm7xD34HZ9IiDhsiOZGBNpw3lSuWCOuGVkSe7vO8hBod3y29Y
         GRNA==
X-Gm-Message-State: AOAM532IUsb/pJQqcO07aeLyBnZ/Mzbq+1ibYepvMXchwyQk7WQLfI2M
        97oCxSm4sxKZK3JeAf0/yohArw==
X-Google-Smtp-Source: ABdhPJx64meobaKTgi0GjRMUmb6O9KpahKfmhFoA0xe7yKucBhLYjaL6ZJ9ML1dmtTIlR49E3OuD1A==
X-Received: by 2002:a17:90a:2309:: with SMTP id f9mr1923822pje.235.1596163992775;
        Thu, 30 Jul 2020 19:53:12 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id r77sm8390953pfc.193.2020.07.30.19.53.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 19:53:12 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in io_uring_setup (2)
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+9d46305e76057f30c74e@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, Markus Elfring <Markus.Elfring@web.de>
References: <20200731014541.11944-1-hdanton@sina.com>
 <20200731022859.6372-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <89fcf8d1-3c87-bd07-b974-e9c012eb1eea@kernel.dk>
Date:   Thu, 30 Jul 2020 20:53:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200731022859.6372-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/30/20 8:28 PM, Hillf Danton wrote:
> 
> On Thu, 30 Jul 2020 20:07:59 -0600 Jens Axboe wrote:
>> On 7/30/20 7:45 PM, Hillf Danton wrote:
>>>
>>> Add the missing percpu_ref_get when creating ctx.
>>>
> [...]
>> The error path doesn't care, the issue is only after fd install. Hence
> 
> Yes you are right.
> 
>> we don't need to grab a reference, just make sure we don't touch the ctx
>> after fd install.
> 
> This is a cure, not a generic one as it maybe a potpit for anyone adding
> changes here since on. But that's quite unlikely as this is a way one-off
> path.
> 
>> Since you saw this one, you must have also seen my
>> patch. Why not comment on that instead?
> 
> You know, it is unusually hard to add anything in your field, and I hit the
> send button after staring at the screen for two minutes, given a different
> approach.

The patch was sent out 7h ago. My suggestion would be to at least see
what other people may have commented or posted on the topic first, instead
of just ignoring it point blank and sending something else out.

A good way to start a discussion would be to reply to my email in this
very thread, with why you think an alternate solution might be better.
Or point out of there are errors in it. Just ignoring what else has been
posted just comes off as rude, to be honest.

You've got patches in for io_uring in the past, and I'd surely like to
see that continue. But working together is helping each other out, not
working in a vacuum, pretending not to see what else is being discussed
or posted.

-- 
Jens Axboe

