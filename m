Return-Path: <io-uring+bounces-9583-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C0C5B45020
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 09:43:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37F3816E16F
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 07:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C3826B2A5;
	Fri,  5 Sep 2025 07:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="blraISC6"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F2325949A
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 07:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757058184; cv=none; b=j6x35kC4IufV3pRvge49JP3mTe/ygyzMELFUMHDst0Kd5GDkDUm/N54tPQe+pKkT37ryRl0rwomiRqsoblBM65kkp9vlliab1qMjzYSiUk/w7DMWupwPsRuD8GuWSfEck7xWgwR+JDYs8Y6h1FDhMmEvw8gBVUFcQ1zWBhUH4s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757058184; c=relaxed/simple;
	bh=pVM5vIb/BptuM168eR1sfolL9rBvq9Vpfg6rZzCtIK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sixJEgc3cLG9g0KLxs+adCQQZfpNeNQofYNaOLEk+ax4Im6eSLJprjsttq54vPXnsRh2p8xDnhQIrudc4GmrYa5oVDMWSdRmuY5V/8tEbpldoWblETsZ78Twmp0/aCmbYE4kDl65qe+JTD+9j5B+ffOb7Rp8lnC7dSjLrB5Bn6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=blraISC6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757058182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z6Cco/gArEI1B3IDLJ4230/RV/hI9+YhFOcMJyqZnI8=;
	b=blraISC67iQxEHiwqAvIg5pbjdzp8PqnexSdRnRpJDaugZQl1d+vdq2VJTvSOXHfYu81bM
	cJAIysKT4kRqGNOaFGWEEzEjLQJwDbK9zSxRZ6iJdLGL+MoHYJEjBIBef/0QAEU4Je5ffh
	7XFBEolOXvQTPstuODsBXY3y1+8bX94=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-MAuwpLb7Ovu6xGkMQ-PXAA-1; Fri, 05 Sep 2025 03:42:58 -0400
X-MC-Unique: MAuwpLb7Ovu6xGkMQ-PXAA-1
X-Mimecast-MFC-AGG-ID: MAuwpLb7Ovu6xGkMQ-PXAA_1757058177
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3e26b5e3f41so479699f8f.1
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 00:42:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757058177; x=1757662977;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z6Cco/gArEI1B3IDLJ4230/RV/hI9+YhFOcMJyqZnI8=;
        b=o3fV3SkKHRLj7TyzzAr9eyy7n0V+eGmoUE17N3dw8hduzh4e3HCBAzFWoauJ/Txluf
         2GzML/NSa/GmHf1LPpdILfgLQeNjzb3JstOCJPVMhZi1vgmdlGKwGk8dlPbxigtOAF3M
         it/+z6B9di2pJvge2wv07Fs91H41XDuMGBNuJYh3PyqT/i9K2h3i2wKhzgBnSxIszjIQ
         TGT8Pqaknm+JQblRpu8EW4U50dHA5Mw/FBxnYG6ggrPutlspSmeXnHM49B7O9U8JeLPD
         iPQoX+KzXu2g8lG8a/83Ihq9+s+KifEKGt0FvmLoi5DMay4tdBR0AKio0O72z2hSu9OB
         WPcA==
X-Forwarded-Encrypted: i=1; AJvYcCUKbr59S8eDt/3nLWTINlVDpplc2sV6hpGwBBPNOLwaP4GqFnUt3eJM7iOR0ZkKhfN4tVsjS0mmsw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw68CUY8fFPyxOF7QrSsBTcc4qTUqEVkDtnBw0Bd69gBgLDVZ0G
	Xp5f1wFdv67kJJC7shitpH59h2EcvH1zA251K0OkZ8Kn6GZg8zApWc2kf/aK5l2beGsA42aBcDw
	VDPr8yB8xCMGUT0tYXiUMwT9Un3fXF4mq6IC2KKrCC9LXle5xL09GA1+ER0wE
X-Gm-Gg: ASbGncs6jsc+k7bSxAQmjWc+e/DoKGEtR3myMH0HSVrx/HPKAtDeuLBo/PDRVhC8oBS
	q6AtHeqs2cI/CwJfsDgWAaLoTEEGuuVg5XwhVe3F+crsda5+Kj63kclLB9n8BI9D0OGmOzN2YW9
	4+kCZeSr83O2JxeXLOXNaoor0Mvq33R+2geVlEuI3d6Ifqth81vjmxWflV1wrHkAxxT68yGYSQ7
	lqlDkkrrjwLek6ab3OOSScYD04Y5FGmOf1DstFZ9KJ+0SVMg87Mx3/HKai6TxwHo5qRjAxUY+1U
	nmwOe04pKxc4DSSGGzAL4006eNmJ3lCofZQXt8AixM7l8T/PUzszxIHp1IiBHxUnsNca+YyGN3J
	iXH37bZID6OTIkitB6CsYUCkO4P57/fIHZfD/YMwQXX0PrrBjS+817+Ft
X-Received: by 2002:a05:6000:2c09:b0:3d4:6abb:7e01 with SMTP id ffacd0b85a97d-3d46abb82d7mr14730338f8f.41.1757058177449;
        Fri, 05 Sep 2025 00:42:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdkmonAdN8kZC7Auh4/5UvF8c34qVbrqn3f2dXFG6i4O0vhisGnRXPONU3jqW9KXcFWL0j8w==
X-Received: by 2002:a05:6000:2c09:b0:3d4:6abb:7e01 with SMTP id ffacd0b85a97d-3d46abb82d7mr14730319f8f.41.1757058177001;
        Fri, 05 Sep 2025 00:42:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fb9dbfsm30535206f8f.43.2025.09.05.00.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 00:42:56 -0700 (PDT)
Message-ID: <cc7f03f8-da8b-407e-a03a-e8e5a9ec5462@redhat.com>
Date: Fri, 5 Sep 2025 09:42:55 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Read in
 io_sqe_buffer_register
To: Jens Axboe <axboe@kernel.dk>,
 syzbot <syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>
References: <68b9b200.a00a0220.eb3d.0006.GAE@google.com>
 <54a9fea7-053f-48c9-b14f-b5b80baa767c@kernel.dk>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <54a9fea7-053f-48c9-b14f-b5b80baa767c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.09.25 01:20, Jens Axboe wrote:
> On 9/4/25 9:36 AM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    4ac65880ebca Add linux-next specific files for 20250904
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1785fe62580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=fbc16d9faf3a88a4
>> dashboard link: https://syzkaller.appspot.com/bug?extid=1ab243d3eebb2aabf4a4
>> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13f23e62580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12cb6312580000
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/36645a51612c/disk-4ac65880.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/bba80d634bef/vmlinux-4ac65880.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/e58dd70dfd0f/bzImage-4ac65880.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com
>>
>> ==================================================================
>> BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:68 [inline]
>> BUG: KASAN: null-ptr-deref in _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
>> BUG: KASAN: null-ptr-deref in PageCompound include/linux/page-flags.h:331 [inline]
>> BUG: KASAN: null-ptr-deref in io_buffer_account_pin io_uring/rsrc.c:668 [inline]
>> BUG: KASAN: null-ptr-deref in io_sqe_buffer_register+0x369/0x20a0 io_uring/rsrc.c:817
>> Read of size 8 at addr 0000000000000000 by task syz.0.17/6020
>>
>> CPU: 0 UID: 0 PID: 6020 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
>> Call Trace:
>>   <TASK>
>>   dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>>   kasan_report+0x118/0x150 mm/kasan/report.c:595
>>   check_region_inline mm/kasan/generic.c:-1 [inline]
>>   kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:200
>>   instrument_atomic_read include/linux/instrumented.h:68 [inline]
>>   _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
>>   PageCompound include/linux/page-flags.h:331 [inline]
>>   io_buffer_account_pin io_uring/rsrc.c:668 [inline]
>>   io_sqe_buffer_register+0x369/0x20a0 io_uring/rsrc.c:817
>>   __io_sqe_buffers_update io_uring/rsrc.c:322 [inline]
>>   __io_register_rsrc_update+0x55e/0x11b0 io_uring/rsrc.c:360
>>   io_register_rsrc_update+0x196/0x1a0 io_uring/rsrc.c:391
>>   __io_uring_register io_uring/register.c:736 [inline]
>>   __do_sys_io_uring_register io_uring/register.c:926 [inline]
>>   __se_sys_io_uring_register+0x795/0x11b0 io_uring/register.c:903
>>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>   do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f99b1f8ebe9
>> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007f99b2d88038 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
>> RAX: ffffffffffffffda RBX: 00007f99b21c5fa0 RCX: 00007f99b1f8ebe9
>> RDX: 00002000000003c0 RSI: 0000000000000010 RDI: 0000000000000003
>> RBP: 00007f99b2011e19 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000020 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007f99b21c6038 R14: 00007f99b21c5fa0 R15: 00007ffeadfa5958
>>   </TASK>
>> ==================================================================

#syz test

 From bfd07c995814354f6b66c5b6a72e96a7aa9fb73b Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Fri, 5 Sep 2025 08:38:43 +0200
Subject: [PATCH] fixup: mm/gup: remove record_subpages()

pages is not adjusted by the caller, but idnexed by existing *nr.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
  mm/gup.c | 2 ++
  1 file changed, 2 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index 010fe56f6e132..22420f2069ee1 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2981,6 +2981,7 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t 
*pmdp, unsigned long addr,
  		return 0;
  	}

+	pages += *nr;
  	*nr += refs;
  	for (; refs; refs--)
  		*(pages++) = page++;
@@ -3024,6 +3025,7 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t 
*pudp, unsigned long addr,
  		return 0;
  	}

+	pages += *nr;
  	*nr += refs;
  	for (; refs; refs--)
  		*(pages++) = page++;
-- 
2.50.1


-- 
Cheers

David / dhildenb


