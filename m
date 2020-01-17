Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB49140D93
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 16:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgAQPPT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 10:15:19 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:35822 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbgAQPPT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 10:15:19 -0500
Received: by mail-io1-f65.google.com with SMTP id h8so26387837iob.2
        for <io-uring@vger.kernel.org>; Fri, 17 Jan 2020 07:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xT36z7Bws+eNMrBqJwUz2n2zjVjB7kHFvqu4jvdQ6B0=;
        b=FpewnYb1Ej1M/mImdDlN91H9JMzylIu87dY+nCfwkMtw1F+OJzKAbhee4B48wNFei0
         8ggwNnAiupYtUrba0+Q82IZzGJdePvbmYKUfJntb36wkp9Q2n7wPoh47ttRzyrYAs9VR
         RuoMZ8VFVk0N7L7Sj0iFCAjdwFYw5YFVxCFkb/hqQv8oVSk8qZShfq6OiPjCUC1tH4ZV
         jRW8TuQZWpJC7kntANuNMIxThcapmfqABYEppN2J6BmVviHZTJ73Uf4GxTA8adFe3rDX
         v9diqHWOKvk7kClq22R22tz0jqShYsHEJRzrREiLWM8tCVXszrKJHX9P+lW8qQAoyBeH
         kx0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xT36z7Bws+eNMrBqJwUz2n2zjVjB7kHFvqu4jvdQ6B0=;
        b=gBAIHTJODu2KKkPioTpFrKF23KkRT+uht6tYKyr3U+ny7MPC8eazN+F++uopcBKMw+
         l7e5YYfeVlyBMXKqGtA4tT4lVJ5zLpG69yhcdMAHMTlfMTDpYofPz7URASYGdAZl2U61
         FNvdBA2ZQ++y1ZPdF8Vw5zSjtv1zrLPxcmoS3JY37AXlusDzYcpVFgGmhFYVdr73nG15
         K1l3gU9jqehH64U54F2dlYvylVRZzZXGAm06RRJ0PILuBxIIbX9FcztxzE699Ei7HJoQ
         Tl96BYldz7MNtfp8Tx0Dele2a6ifxKRVfILddrs1lMEErYHBSdwUI5yFlmeelfJ3i93+
         EETA==
X-Gm-Message-State: APjAAAXAB0M60zXNJh4wdO+3ZirliqcSevHr0a5dRYhGh2KlPNrcnSue
        qCsCpF7KNhgEtJ9uSPuuqqMfVw==
X-Google-Smtp-Source: APXvYqyg8ZcdCV3Zf0gHKPFV/yug1ekIoH+28vBeDiDFQ7yqqnG50OvFSrAFhL9BvB4d8AMqK9HTeg==
X-Received: by 2002:a02:2a08:: with SMTP id w8mr33919839jaw.86.1579274118151;
        Fri, 17 Jan 2020 07:15:18 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b3sm7962630ilh.72.2020.01.17.07.15.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 07:15:17 -0800 (PST)
Subject: Re: [PATCH v2] io_uring: add support for probing opcodes
To:     Mark Papadakis <markuspapadakis@icloud.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>
References: <886e284c-4b1f-b90e-507e-05e5c74b9599@kernel.dk>
 <76278FD6-7707-483E-ADDA-DF98A19F0860@icloud.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7094d85e-1f7e-83c2-cb35-9fb699118167@kernel.dk>
Date:   Fri, 17 Jan 2020 08:15:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <76278FD6-7707-483E-ADDA-DF98A19F0860@icloud.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/17/20 12:42 AM, Mark Papadakis wrote:
> I 've been thinking about this earlier.  I think the most realistic
> solution would be to have kind of website/page(libiouring.org?), which
> lists all SQE OPs, the kernel release that first implemented support
> for it, and (if necessary) notes about compatibility.
> 
> - There will be, hopefully, a lot more such OPS implemented in the
> future - By having this list readily available, one can determine the
> lowest Linux Kernel release required(target) for a specific set of OPs
> they need for their program. If I want support for readv, writev,
> accept, and connect - say - then I should be able to quickly figure
> out that e.g 5.5 is the minimum LK release I must require - Subtle
> issues may be discovered, or other such important specifics may be to
> be called out -- e.g readv works for < 5.5 for disk I/O but (e.g)
> "broken" for 5.4.3. This should be included in that table

The problem with this approach is that io_uring is (mostly) a one man
show so far, and maintaining a web page is not part of my core skill
set, nor is it something I want to take on. It'd be awesome if someone
else would step up on that front. Might be easier to simply keep the
liburing man pages up-to-date and maintain the information in there.

I think a lot of the issues you mention above are early teething issues,
hopefully won't be much of a concern going forward as things solidy and
stabilize on all fronts. So we're left with mostly "is this supported in
the kernel I'm on" kind of questions, which would hopefully be request
specific.

One thing that has been brought up is that we could add an opcode
version. There's an u8 reserved field next to the opcode, that could be
turned into

	__u8 version;

in the future, which would allow us to differentiate types of supported
for an individual opcode. Your readv example would work with that, for
instance.

> Testing against specific SQE OPs support alone won't be enough, and it
> will likely also get convoluted fast.  liburing could provide a simple
> utility function that returns the (major, minor) LK release for
> convenience.

I'm not a huge fan of versioning, exactly because it requires some other
source of information to then cross check a version number with
features. Then the application needs to maintain it to. It also totally
breaks down for backports, where you may only selectively backport
features to an older kernel. You can't represent that with a major.minor
that is sytem wide. The table can.

-- 
Jens Axboe

