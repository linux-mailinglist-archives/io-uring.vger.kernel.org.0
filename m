Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF043D3009
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 01:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbhGVWZx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jul 2021 18:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbhGVWZx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jul 2021 18:25:53 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0F4C061757
        for <io-uring@vger.kernel.org>; Thu, 22 Jul 2021 16:06:27 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id e5so1123937pla.6
        for <io-uring@vger.kernel.org>; Thu, 22 Jul 2021 16:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UX80Zg7G9R6TR4N/QY6RPnMxTLMXDyaEGBPpPaGdslU=;
        b=Mg272/+koMCLUwqtk4UiQ2FwkocNUANXeoIvbzzl4CKBPyxLKbsI7h96iSHN42yWhE
         AqWXzmBjDDIzYE6JHKttstrtZgD1/8gbKqUiwPfeEss8H0bH9SYmpXKwTKG26eW6OgSx
         xFzvlWbogQ3OF8Dyv+VofXyCU5czG3ew0oCq68JlMQEwk1Xy6W9B75Hk/tHqgbBpVaqM
         iD9Id6jg8IB3PEnArAVcl6xcsO2K5n6FsYmkHkm4/mzRSkFuSc34hy/fbHKDuxWNfm25
         UrnP0Uktpj/PvnfPcgkMxRmaU1TmEWPX4vOmEDQy18dnPRK1nCZglkz5CNsxOXcXC/fe
         0XRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UX80Zg7G9R6TR4N/QY6RPnMxTLMXDyaEGBPpPaGdslU=;
        b=HgrQhadbAOpfe1NAhcNYvbWC4aAQsQO56/CwVZ0SBee98poWjzgL/eG613hLPoi1jn
         XFWQSpJOhHCTWBpgl3EtmdkwmG21FUjaWpfCbcEV4cdm1vYGOFnWcyTsXm28wbVbZm9o
         PD08E+FMugyDKH2A/zkHVR9XbQFxaCdJcE6cAAuyAUYbc+e6cnUlFYpfY19VXdjZ5GH9
         Fgnca86rBkYxcQJsL8edaUY19fG1tX8pQYQhZIvJtsF8NfBusdnmTmkY0o3u38eBMCxE
         5+i2gG0mkosXD5oMHlAnJasNt/kDE5uXKxGmo2b8T4H36Lcy+DFcsxZq7BYnYDQzUukf
         cavw==
X-Gm-Message-State: AOAM533PqHHk5vLxSkP+isggN/qvubIXe8jbPKzi94mkh+knNl/bHV6v
        lrIJTLtWDqDpM6RCLDNkjhl69/CkcXVEUVvP
X-Google-Smtp-Source: ABdhPJwhJXwMjQftVM62LeKSP5qwoSyOVoOFdj8rVQZwshe3ZY0gW+v33Jy7n2UP5XHHU/LRSHQGlA==
X-Received: by 2002:a63:409:: with SMTP id 9mr2213703pge.132.1626995186236;
        Thu, 22 Jul 2021 16:06:26 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id w6sm35661105pgh.56.2021.07.22.16.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 16:06:25 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: refactor io_sq_offload_create()
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <cover.1618916549.git.asml.silence@gmail.com>
 <939776f90de8d2cdd0414e1baa29c8ec0926b561.1618916549.git.asml.silence@gmail.com>
 <YPnqM0fY3nM5RdRI@zeniv-ca.linux.org.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <57758edf-d064-d37e-e544-e0c72299823d@kernel.dk>
Date:   Thu, 22 Jul 2021 17:06:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YPnqM0fY3nM5RdRI@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/22/21 3:59 PM, Al Viro wrote:
> On Tue, Apr 20, 2021 at 12:03:33PM +0100, Pavel Begunkov wrote:
>> Just a bit of code tossing in io_sq_offload_create(), so it looks a bit
>> better. No functional changes.
> 
> Does a use-after-free count as a functional change?
> 
>>  		f = fdget(p->wq_fd);
> 
> Descriptor table is shared with another thread, grabbed a reference to file.
> Refcount is 2 (1 from descriptor table, 1 held by us)
> 
>>  		if (!f.file)
>>  			return -ENXIO;
> 
> Nope, not NULL.
> 
>> -		if (f.file->f_op != &io_uring_fops) {
>> -			fdput(f);
>> -			return -EINVAL;
>> -		}
>>  		fdput(f);
> 
> Decrement refcount, get preempted away.  f.file->f_count is 1 now.
> 
> Another thread: close() on the same descriptor.  Final reference to
> struct file (from descriptor table) is gone, file closed, memory freed.
> 
> Regain CPU...
> 
>> +		if (f.file->f_op != &io_uring_fops)
>> +			return -EINVAL;
> 
> ... and dereference an already freed structure.
> 
> What scares me here is that you are playing with bloody fundamental
> objects, without understanding even the basics regarding their
> handling ;-/

Let's calm down here, no need to resort to hyperbole. It looks like an
honest mistake to me, and I should have caught that in review. You don't
even need to understand file structure life times to realize that:

	put(shared_struct);
	if (shared_struct->foo)
		...

is a bad idea. Which Pavel obviously does.

But yes, that is not great and obviously a bug, and we'll of course get
it fixed up asap.

-- 
Jens Axboe

