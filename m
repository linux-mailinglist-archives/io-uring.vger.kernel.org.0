Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAEC221548
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 21:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgGOTnz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 15:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgGOTny (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 15:43:54 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6356C061755;
        Wed, 15 Jul 2020 12:43:53 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id ga4so3417798ejb.11;
        Wed, 15 Jul 2020 12:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iaLGexaSw4FQvPhMT9GEqm7GZkiMzvFUAf6J/Ie1zOA=;
        b=ExaZGhoDR2ndnOqNntbrwWNIBpldsMx/kGfINn/oieckd2ZAnOdyl8/0/8NgHgHHeC
         onOQwXpudiyWKJ+I0SkS0OveCxqZMjrrZgN7gD6tleGHGZBaaR1axLFbbrO6QCnCO4xP
         1FKB4tJpPwaXljdhatldDhQH3ASqG9HqU7vyD5QClCxfZNfLKFSbPq0oDDR8wsWv5Dij
         BPasKLZwzd44d/jwCpQhs37K0FROo0KEPrMVLTa7TYZdTt+7Y5pHoWFnYVNqwQaMR+Eh
         9ozGo+/geqdnLHZAulFsZ/02Mrasqt7Sk0Rc9NJlYzdahvbizQbjPF9adHNZJqq9PzgD
         puRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=iaLGexaSw4FQvPhMT9GEqm7GZkiMzvFUAf6J/Ie1zOA=;
        b=OAFWkX+9bG6MMfYehZdwCDGN38sL9jvVtGnrba4CqrFWOX05TAdupHVKX3x/3d+LAS
         ZSK764MtqdW1Jeju79j2CVakYlIjuZTTnBGDZweDnUZ518l2aYTZxldO+E8S33b0IIQ+
         IadP6sw3vByMNrqdOCVH9o6zh5AjrAiqRmdFdzCaQMbDEUmbF40YrN+jgx0Tt9NkFKJF
         iKCQkxWSgJJH/UwdKfunt5EF26KprV2FV76aNgzlrDY+YaYcZx2EMjEpu3mvwUbectbn
         qryclx1OBO7IQjz3o0E/m0g9EhtqK9GwIEUNr183vfTaq/xIshzANnek+zwp0tGUjzgV
         VkCA==
X-Gm-Message-State: AOAM531fi2+tLtWahqrbDj3oq+8H28SANoxaKanI66CdIaDDpi2fTyOZ
        73vRZN0MMDwth9bM1S4UEINNdrPgXog=
X-Google-Smtp-Source: ABdhPJyzNKFw1M0wjMMFZxBhJp2hgNFM/MGMacBI9InXmClalXZd3CNIgy0jyccKprE3eYn0Z7dOWA==
X-Received: by 2002:a17:906:1402:: with SMTP id p2mr528029ejc.126.1594842232060;
        Wed, 15 Jul 2020 12:43:52 -0700 (PDT)
Received: from [192.168.43.238] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id o6sm3112602edr.94.2020.07.15.12.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 12:43:51 -0700 (PDT)
To:     Matthew Wilcox <willy@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        strace-devel@lists.strace.io, io-uring@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAJfpegu3EwbBFTSJiPhm7eMyTK2MzijLUp1gcboOo3meMF_+Qg@mail.gmail.com>
 <D9FAB37B-D059-4137-A115-616237D78640@amacapital.net>
 <20200715171130.GG12769@casper.infradead.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: strace of io_uring events?
Message-ID: <7c09f6af-653f-db3f-2378-02dca2bc07f7@gmail.com>
Date:   Wed, 15 Jul 2020 22:42:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200715171130.GG12769@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/07/2020 20:11, Matthew Wilcox wrote:
> On Wed, Jul 15, 2020 at 07:35:50AM -0700, Andy Lutomirski wrote:
>>> On Jul 15, 2020, at 4:12 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>
>>> <feff>Hi,
> 
> feff?  Are we doing WTF-16 in email now?  ;-)
> 
>>>
>>> This thread is to discuss the possibility of stracing requests
>>> submitted through io_uring.   I'm not directly involved in io_uring
>>> development, so I'm posting this out of  interest in using strace on
>>> processes utilizing io_uring.
>>>
>>> io_uring gives the developer a way to bypass the syscall interface,
>>> which results in loss of information when tracing.  This is a strace
>>> fragment on  "io_uring-cp" from liburing:
>>>
>>> io_uring_enter(5, 40, 0, 0, NULL, 8)    = 40
>>> io_uring_enter(5, 1, 0, 0, NULL, 8)     = 1
>>> io_uring_enter(5, 1, 0, 0, NULL, 8)     = 1
>>> ...
>>>
>>> What really happens are read + write requests.  Without that
>>> information the strace output is mostly useless.
>>>
>>> This loss of information is not new, e.g. calls through the vdso or
>>> futext fast paths are also invisible to strace.  But losing filesystem
>>> I/O calls are a major blow, imo.

To clear details for those who are not familiar with io_uring:

io_uring has a pair of queues, submission (SQ) and completion queues (CQ),
both shared between kernel and user spaces. The userspace submits requests
by filling a chunk of memory in SQ. The kernel picks up SQ entries in
(syscall io_uring_enter) or asynchronously by polling SQ.

CQ entries are filled by the kernel completely asynchronously and
in parallel. Some users just poll CQ to get them, but also have a way
to wait for them.

>>>
>>> What do people think?
>>>
>>> From what I can tell, listing the submitted requests on
>>> io_uring_enter() would not be hard.  Request completion is
>>> asynchronous, however, and may not require  io_uring_enter() syscall.
>>> Am I correct?

Both, submission and completion sides may not require a syscall.

>>>
>>> Is there some existing tracing infrastructure that strace could use to
>>> get async completion events?  Should we be introducing one?

There are static trace points covering all needs.

And if not used the whole thing have to be zero-overhead. Otherwise
there is perf, which is zero-overhead, and this IMHO won't fly. 

>>
>> Let’s add some seccomp folks. We probably also want to be able to run
>> seccomp-like filters on io_uring requests. So maybe io_uring should
>> call into seccomp-and-tracing code for each action.
> 
> Adding Stefano since he had a complementary proposal for iouring
> restrictions that weren't exactly seccomp.
> 

-- 
Pavel Begunkov
