Return-Path: <io-uring+bounces-6327-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 56144A2D709
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 16:49:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9F8C7A379B
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 15:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 319C92475D7;
	Sat,  8 Feb 2025 15:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A22tfOrj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC191990DB;
	Sat,  8 Feb 2025 15:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739029788; cv=none; b=pcLxQ/x69Wbgpn/ldC2Ofs7N8Ox4MaJjEBt7ow5nxVoNSY4FMA4i2EG0ceC8lXhxqAxrWAMxgdiFEuzEx9uNk5/8PgL+bbdruf69vB8UuQGaPcrGN9JBF0mJ+k0O1J2hx6wGpC8SXqS86BbrxZXYB3fB+XHp+cYxnYUBes+XHh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739029788; c=relaxed/simple;
	bh=ZrdwyVQsygUXXi+QfnaZu4lDBNZHEuJf32aJZrB7qCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nxaUG5hKNneQfNoE/pzhg4ZBqh1UVHC0KDpfVWcEj6mPkFNwXzdCTRzocKFjbdlANsVgKenziwNMpdXi0UYKq+srnMXyMle6fegn9HXcVpOdvekn6dWgNPHCv2IUxV77zCkuV36eKOdZbkUQIeD+T6x4ZpVBlslH6sWmJqtdyXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A22tfOrj; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aa68b513abcso567434666b.0;
        Sat, 08 Feb 2025 07:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739029784; x=1739634584; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xf1jLQbPTI19WcGCKwB7IveX87RvDlQZm4hpR+Jqi0Y=;
        b=A22tfOrjr2EJ0Y3cbW4eGN2alUVbFocnZ8hf2aXdZUd9UwhxoN5pIPj7PodL/iKdq8
         ZE17AwLxbESltT/ZlohH10+gyHAGHplLthC8yCN7Tw4P52jQJ1/KnTLQRP98b1OdLGGT
         1mfE4QC9ATBuR5k5gIPkqAtVXn3E3uO2uSRBvV4VYc8wfIGH8LnxvyrSSOH+sB2LYqLQ
         A07QBSv9mzRsKRAKcUum29c83+gLRRogwvAyBlui1ISnHwadIBL8cpIPgKLWKQ5165zg
         MepfhUTkHY6SclAHnAaOkjteeBdpsw5OtpO59emHALfBFSr4Y3u+/6aYstBPVNIbN8B2
         dX3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739029784; x=1739634584;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xf1jLQbPTI19WcGCKwB7IveX87RvDlQZm4hpR+Jqi0Y=;
        b=DUYUScNDDxDvXMiolnUzyEJNx38h7zx0485Hl2b2lpzlHp/i0IMKPhxG3/SsCg0BfU
         NnA7qZVirtrbFEGZSVfBbcobpGSfjQaDtMcQlJniERSfL3N+VegzJccDnciEz0Mj9Mhl
         ED0nUr/RLaEazA0l0ekzeY60ML8aegu4jLNen1zlPB/1ff/6ZnWKGLm0lTFCiNXf807x
         pWTO6viKztJ2fbEhN0JbdFv1/d7lASElCjl+2TF6NNYPbeRWazIVzc5xG0hoM11pebCM
         Whs5mlKPSWMj1R/nRDklkpVn1zo9/7Ic0NKpl8kGFDDe27xB6HiYLGbKTIMrkgZl6psZ
         k6nA==
X-Forwarded-Encrypted: i=1; AJvYcCUX60UnmRmFbkmn2FcTshRy9Kww+IUBM1XzzpIK+TLeclLOfyEPHLPsFDY+bWp149k5LMz6gT9Puw==@vger.kernel.org, AJvYcCVGst9aY6Ss9EYKTcE/Lxq2xde1IaxoRe2oPjdr1K7zo0torxxGQAJkqs5HZOVGTSA+IRpPpMfCihMe/5U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwH4/kCuLCZC+mA6Vnp4fCDXfg6ri0nSt0b0Xrigefg+YMsoG2w
	Kue0Fq1tQLA0z+cCFDxOJyxN0Zp4Nyn1L5tt/IAR/wnCnPam94bD
X-Gm-Gg: ASbGncvAsY1vOX8csdP7Izcm8vzLSrFuDBSOBf3Fktz7pAn5dx+CbEcm8kPMgozxW7D
	CAKwHff9AEYg86Jl5MVy1DIW7XKbNLe27gALNxgveMTrjrdSMWjPQQFVruTbTLldEgjF+SF9QrW
	DXIo5CAVo0f2vV1yAaM2kwXudftTApDhogtjE+UBSkkTEitSjRmzkYy+AawCM6f7GFwBSsEaJ3u
	klgmOY0hjpbBZ0Lwz+uudM+zM13V4NuPK9mOHf9dH1HwKbF224Mv5IAQDwQanzj+5848u+gkgom
	8PHWaWujtaJKmVp7JODVpaa5aQ==
X-Google-Smtp-Source: AGHT+IHJquoREIzpdt9NN5spCyISGwZLJcUAkz2K2O/6sEgxG1dRtuB/3nsHrahWNxwxoeW3flmtKw==
X-Received: by 2002:a17:906:585b:b0:ab7:8d90:29bf with SMTP id a640c23a62f3a-ab78d902ceemr514797066b.17.1739029784303;
        Sat, 08 Feb 2025 07:49:44 -0800 (PST)
Received: from [192.168.8.100] ([148.252.133.220])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab772f84417sm496704866b.53.2025.02.08.07.49.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2025 07:49:43 -0800 (PST)
Message-ID: <67d9624f-5785-4c5b-993f-db9f08ca0215@gmail.com>
Date: Sat, 8 Feb 2025 15:49:47 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] io_uring: add support for kernel registered bvecs
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, ming.lei@redhat.com, axboe@kernel.dk
References: <20250203154517.937623-1-kbusch@meta.com>
 <20250203154517.937623-4-kbusch@meta.com>
 <b36f0c87-71ad-444f-b234-f71953ca58ba@gmail.com>
 <Z6YkFsathkU6ltTS@kbusch-mbp>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z6YkFsathkU6ltTS@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/7/25 15:17, Keith Busch wrote:
> On Fri, Feb 07, 2025 at 02:08:23PM +0000, Pavel Begunkov wrote:
>> On 2/3/25 15:45, Keith Busch wrote:
>>>    		struct io_rsrc_node *node;
>>>    		u64 tag = 0;
>>> +		i = array_index_nospec(up->offset + done, ctx->buf_table.nr);
>>> +		node = io_rsrc_node_lookup(&ctx->buf_table, i);
>>> +		if (node && node->type != IORING_RSRC_BUFFER) {
>>
>> We might need to rethink how it's unregistered. The next patch
>> does it as a ublk commands, but what happens if it gets ejected
>> by someone else?  get_page might protect from kernel corruption
>> and here you try to forbid ejections, but there is io_rsrc_data_free()
>> and the io_uring ctx can die as well and it will have to drop it.
> 
> We prevent clearing an index through the typical user register update
> call. The expected way to clear for a well functioning program is
> through the kernel interfaces.

What I'm saying, it's a sanity check, but it doesn't prevent it
from happening from other paths, and I understand that you're
trying to cover for that.

> Other than that, there's nothing special about kernel buffers here. You
> can kill the ring or tear down registered buffer table, but that same
> scenario exists for user registered buffers. The only thing io_uring

For registered buffers the user can and will have to handle it, but in
case of this proposal the end ublk user wouldn't even know there is
an io_uring and registered buffers, so ultimately the ublk driver will
have to handle edge cases. And for ublk driver to be able to handle it
well even in case of ublk server failures, it'll need to be able to wait
until io_uring releases the buffer.

For example, the ublk server crashes, which closes io_uring => there
is no way to do unregister cmd anymore. IIUC, the ublk driver will
want to complete the block request returning an error, but if it's
done before io_uring releases the buffer, the end ublk user may
attempt to reuse the memory while io_uring is still concurrently
writing to / reading from it, which would be disastrous.

One thing I like about ublk unregister cmd though, is that you can
add some more control like reporting back a short IO, but I doubt we
can do it sanely without sending some sort of a notification back
to ublk. So, maybe it should be both, and in case of forced
unregistration ublk will consider it to be a failure. Another option
is to do it all through normal(ish) io_uring buffer unregisteration
path, but maybe enhanced with additional custom arguments. This way
we have only one path doing that.
  

> needs to ensure is that nothing gets corrupted. User registered buffers
> hold a pin on the user pages while the node is referenced. Kernel
> registered buffers hold a page reference while the node is referenced.
> Nothing special.
> 
>> And then you don't really have clear ownership rules. Does ublk
>> releases the block request and "returns ownership" over pages to
>> its user while io_uring is still dying and potenially have some
>> IO inflight against it?
>>
>> That's why I liked more the option to allow removing buffers from
>> the table as per usual io_uring api / rules instead of a separate
>> unregister ublk cmd.
> 
> ublk is the only entity that knows about the struct request that
> provides the bvec we want to use for zero-copy, so it has to be ublk
> that handles the registration. Moving the unregister outside of that
> breaks the symmetry and requires an indirect call.

cmd execution takes 2 indirect calls, not like there is a
difference here.

> 
>> And inside, when all node refs are dropped,
>> it'd call back to ublk. This way you have a single mechanism of
>> how buffers are dropped from io_uring perspective. Thoughts?
>>
>>> +			err = -EBUSY;
>>> +			break;
>>> +		}
>>> +

...

>> ...
>>>    			unsigned long seg_skip;
>>> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
>>> index abd0d5d42c3e1..d1d90d9cd2b43 100644
>>> --- a/io_uring/rsrc.h
>>> +++ b/io_uring/rsrc.h
>>> @@ -13,6 +13,7 @@
>>>    enum {
>>>    	IORING_RSRC_FILE		= 0,
>>>    	IORING_RSRC_BUFFER		= 1,
>>> +	IORING_RSRC_KBUF		= 2,
>>
>> The name "kbuf" is already used, to avoid confusion let's rename it.
>> Ming called it leased buffers before, I think it's a good name.
> 
> These are just fixed buffers, just like user space onces. The only
> difference is where the buffer comes from: kernel or userspace? I don't
> see what the term "lease" has to do with this.

In this particular case, there is a kernel component that expects
it back, that's the leasing part, but thinking about it more, you're
right, the interface can support workflows different from it as well.

I actually like kbuf, but again it's confusing because already used
for an entirely different thing. Maybe it's fine if it doesn't leak
outside of node types.

-- 
Pavel Begunkov


