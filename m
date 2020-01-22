Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC79144A6F
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 04:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgAVDaR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 22:30:17 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33361 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729021AbgAVDaR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 22:30:17 -0500
Received: by mail-pf1-f194.google.com with SMTP id z16so2627953pfk.0
        for <io-uring@vger.kernel.org>; Tue, 21 Jan 2020 19:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qC1RUoM3/NtlqUaitknsdL/RkF2RqwRcZGXGQrwHHKY=;
        b=xDunS1JhkaFpBpNmrHHt1HfTnw54J9IC2Y88T+VYta/x5jNWG2RFv/N42ujfWUn24X
         /+MzbTNjWhtC0f0tXymbdW8Tiy8IjKhTss9krg3EBu4FD4EM0IqAwYTJjR0mNLmGkqXj
         WQa7SFucJDGaL0UIvLo3ChgkS5GrAfy1DBwJ2BOy6jAoSnlpnhwwJdIpX6av4koGEGKo
         +hyNmi5GpLT+8Jfm0ao5ySi8TGkD2R16+zImwPMF8vDolNpH0P4KLt+4BrDKNs/yOVgL
         EnjDEh7dTSvTkMpAptYyhPG5eIKoU/BCYAuIF/vs12hJWJs204Uy7AzMnU1x0/NY2tIM
         4tnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qC1RUoM3/NtlqUaitknsdL/RkF2RqwRcZGXGQrwHHKY=;
        b=Dm5XfUHq2SgGc/BzaI2pN6xdKSvQumN+Kq5X68jONizgmHzKVhxlxLF9fAA3JNjegM
         oaAmL33TqwEbNEzP9rSgIcjs0Ao31f08JLMDv+BR74K1LnlorOm3ka+qpmhf2f1pOuYg
         HjeJo03II3C1J475RMUV4GLNB76yRxZeG8QpjMCGtKqJt8lLe2jmv0NvA6bitZea4Jy3
         zZrYI5AX3nxV0jVAu3fmyQhovjCCdZbL50r5J58koTJIkQj71POq0KzrUvdoMxxUlUdY
         uH9wfJ2pikA/2evB2q7j+VB9R1Yp8tTLh63xOns2bwM6XtqjfXGAALFa8PBgyN8dD8dt
         L+lw==
X-Gm-Message-State: APjAAAX1aMavPNaIC0I1CbgAmJrE8OBoHhrmH6kuH0kjBvBR+DmcoiZn
        uu5jz+SVpa+xKgvBWcZu7AlKQw==
X-Google-Smtp-Source: APXvYqxhcegRJt2QgKyEjpG1x8ZZM5y/oOMvXCQBhSqfFo0E7Xf/evJjiOwY0AZ2FWXYlfbRR99Lhg==
X-Received: by 2002:a62:c541:: with SMTP id j62mr693157pfg.237.1579663816352;
        Tue, 21 Jan 2020 19:30:16 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id k3sm43215290pgc.3.2020.01.21.19.30.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 19:30:15 -0800 (PST)
Subject: Re: [POC RFC 0/3] splice(2) support for io_uring
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>
References: <cover.1579649589.git.asml.silence@gmail.com>
 <63119dd6-7668-a7bc-ea24-1db4909762bb@kernel.dk>
 <45f0b63b-e3e7-ba71-d037-9af1db7bbd98@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8316dfa9-9210-3402-a6c3-4889b6bbdb49@kernel.dk>
Date:   Tue, 21 Jan 2020 20:30:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <45f0b63b-e3e7-ba71-d037-9af1db7bbd98@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/21/20 8:11 PM, Pavel Begunkov wrote:
> On 22/01/2020 04:55, Jens Axboe wrote:
>> On 1/21/20 5:05 PM, Pavel Begunkov wrote:
>>> It works well for basic cases, but there is still work to be done. E.g.
>>> it misses @hash_reg_file checks for the second (output) file. Anyway,
>>> there are some questions I want to discuss:
>>>
>>> - why sqe->len is __u32? Splice uses size_t, and I think it's better
>>> to have something wider (e.g. u64) for fututre use. That's the story
>>> behind added sqe->splice_len.
>>
>> IO operations in Linux generally are INT_MAX, so the u32 is plenty big.
>> That's why I chose it. For this specifically, if you look at splice:
>>
>> 	if (unlikely(len > MAX_RW_COUNT))
>> 		len = MAX_RW_COUNT;
>>
>> so anything larger is truncated anyway.
> 
> Yeah, I saw this one, but that was rather an argument for the future.
> It's pretty easy to transfer more than 4GB with sg list, but that
> would be the case for splice.

I don't see this changing, ever, basically. And probably not a big deal,
if you want to do more than 2GB worth of IO, you simply splice them over
multiple commands. At those sizes, the overhead there is negligible.

>>> - it requires 2 fds, and it's painful. Currently file managing is done
>>> by common path (e.g. io_req_set_file(), __io_req_aux_free()). I'm
>>> thinking to make each opcode function handle file grabbing/putting
>>> themself with some helpers, as it's done in the patch for splice's
>>> out-file.
>>>     1. Opcode handler knows, whether it have/needs a file, and thus
>>>        doesn't need extra checks done in common path.
>>>     2. It will be more consistent with splice.
>>> Objections? Ideas?
>>
>> Sounds reasonable to me, but always easier to judge in patch form :-)
>>
>>> - do we need offset pointers with fallback to file->f_pos? Or is it
>>> enough to have offset value. Jens, I remember you added the first
>>> option somewhere, could you tell the reasoning?
>>
>> I recently added support for -1/cur position, which splice also uses. So
>> you should be fine with that.
>>
> 
> I always have been thinking about it as a legacy from old days, and
> one of the problems of posix. It's not hard to count it in the
> userspace especially in C++ or high-level languages, and is just
> another obstacle for having a performant API. So, I'd rather get rid
> of it here. But is there any reasons against?

It's not always trivial to do in libraries, or programming languages
even. That's why it exists. I would not expect anyone to use it outside
of that.

-- 
Jens Axboe

