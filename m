Return-Path: <io-uring+bounces-8471-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EF8DAE652D
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 14:36:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F06C8188C5C2
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 12:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E99E27A929;
	Tue, 24 Jun 2025 12:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V/z5FSC7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA3B27AC50
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 12:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750768589; cv=none; b=tJQk959FM8DiiI1dosx7Wgp966CS+UgnMCqlnmuhCSsklTLHyxkkAH36fRVjRUsCPlJbnmHZXF3FB7tbDHMuBo4bIFvT0FZ2dq/cXdsd54Sbl2q+IGqoYJ0eW2PwEnVcAJQSAlot35+a2rmQH4hWBpIuOrHOJDG31fkqKoLis8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750768589; c=relaxed/simple;
	bh=9gm45ymZGg8HCoUIEQEjr6ntIeZD8T7p5hY2VcTdYxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KCGH0Qml389RLuaJySFxWBakS4+MgwlHjgVWoN+HLgI/5Fi2Sb/ImOUQh0UHplg5W3n15YmGFDBpTqQASMfXlTcB+r1oyfSO1FBeo6W+0gARvl5o0XPnIpsWbh9kJjucIwkH+qhmi0z0uc2uMCfMeP5eIh9y58qxxR38h21KSks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V/z5FSC7; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-adb2bd27c7bso804443966b.2
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 05:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750768586; x=1751373386; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zVyUINIYgz5yt6gpGTaIWf138BWlcEMnD4ZnKHcbVKM=;
        b=V/z5FSC7ynYQmqCuPGD5B/08Uk/uA7P9cLk1RuqG8W2W2ReX1a90e7/f4lT5zPaxIK
         h/8QlNicwfigv8QRqN+UnOkhx04D2Yga6hEAoGMMQsEL63qt2rO5ubEaQt7RbI/x5wTZ
         g2PztMEwI8ldk9pGEYY1CK+Pu9JmfQEW2+yAXc3uY+7eDpojP8elxKCsE/9FK9lcWcIy
         Jq4ZZIv5NbMFtFbBrHHZg2P4FzBesWCRoV5hWG7HXRhhwO8OiWdM9SOLfTW+Ams0lFg1
         iflH3xFIB8x+/Mh6eH1RvkUC3xcnfUhCTgVXBVWyGO3x7Z6H88dy8SDrBzbGNlJ2lUlV
         tggg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750768586; x=1751373386;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zVyUINIYgz5yt6gpGTaIWf138BWlcEMnD4ZnKHcbVKM=;
        b=KUEorRtOj1tAuFMUfoCCKDXsoDEFReyhiJ52tbktQW22FcPjXjWqXFRNV48LIO7eu9
         ADh6aTDTNtH4dzH/qD9p+1m/HMMNrkoxiv0sGz38Xc8UgJmA13hT7nNSQAB4Kr4M26FH
         jSj97FPiiFZGQcjpJRhQDFrKZS7BeuUBekFgW+iBn5CMBFSC8GAn4IxMVbVhfPYUK30x
         GM8vdSMPDpg5/MBqpddui8q7vZKmaQSSsQ8SrwqQ9qddsZ0+146g3O5lf9PWYTYGRQN+
         b1pAREmmwFEx0jBSJfQ+qnHqydRe8HDUkO6CkpG2TOIFZuN6vYNTZPZgMWT0pPEUGW2z
         hQCg==
X-Forwarded-Encrypted: i=1; AJvYcCUQsnkxwNuhHToFnrK1PjVRkJgtRD4J/vKL7pEoBGcrTfTv0WMQW2EFVUUPNTwC5B4bKLIIIM0oIw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwmylKjf61sMexEZayKlDSNaZzzMjJE7Lr1BCJ25eHGMc+43Qb2
	JF36s93d9btpHHy6e/5fhBiI8FxfTMOiyLjHvDHTwEqVwt5+ghN2C12kk36AOQ==
X-Gm-Gg: ASbGnctVtQmwtF2mmDkAdRf9pb+X2JZjG3XrZtvIIN6nzwzzLkDpXKx/IKGjtgZKQdd
	fKVue/sr+9EQoNQKro7TMDzpEBW14hHVOWa3mv1oKXIg2oOl//AUvwuHeFmAB7peCnTZss+Pr8X
	Hm6CW+f+wap1SzxWlIGGwlJeeLNWrhJX7bIe1ljwzszepWf3EntCuI/yFNL6Wu6HD5W6eAT9xlC
	rh6kkrseHOhYBDOAFt4QapQGX9uG7QCHpPpjytAaqY/gi09T7N8qwfBnPzO/Uf0wB5Iw6NehGzh
	e6ezps/f9AEtZOFWYQBv+IE661E8yhiLSfruuwUTmCNpdyhhSZ63C6cZHpAI4GD2GqYA3VSOXCA
	=
X-Google-Smtp-Source: AGHT+IFXvAq7tE9US/9943pd9VL1tQQfgwR8xA9rpISF/+vsprbWgybJypWzPdel//qHwiQ5senE1w==
X-Received: by 2002:a17:907:7244:b0:adb:2bb2:ee2 with SMTP id a640c23a62f3a-ae057f1f567mr1549484566b.41.1750768585579;
        Tue, 24 Jun 2025 05:36:25 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::2ef? ([2620:10d:c092:600::1:112b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae0540815c2sm888158966b.94.2025.06.24.05.36.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 05:36:24 -0700 (PDT)
Message-ID: <a3ba3583-8c40-4644-9c0b-a71997f51409@gmail.com>
Date: Tue, 24 Jun 2025 13:37:50 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] io_uring/rsrc: don't rely on user vaddr alignment
To: David Hildenbrand <david@redhat.com>, io-uring@vger.kernel.org
References: <cover.1750760501.git.asml.silence@gmail.com>
 <6a34d1600f48ece651ac7f240cb81166670da23d.1750760501.git.asml.silence@gmail.com>
 <e013216a-c0bb-4ea9-84ee-d3771beaa733@redhat.com>
 <5dcd8826-697b-46c8-a4e7-d1b9802092e8@gmail.com>
 <15ea7028-a5f5-4428-b604-b331cf681be3@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <15ea7028-a5f5-4428-b604-b331cf681be3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/24/25 13:26, David Hildenbrand wrote:
> On 24.06.25 14:20, Pavel Begunkov wrote:
>> On 6/24/25 12:53, David Hildenbrand wrote:
>>> On 24.06.25 12:35, Pavel Begunkov wrote:
>>>> There is no guaranteed alignment for user pointers, however the
>>>> calculation of an offset of the first page into a folio after
>>>> coalescing uses some weird bit mask logic, get rid of it.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Reported-by: David Hildenbrand <david@redhat.com>
>>>> Fixes: a8edbb424b139 ("io_uring/rsrc: enable multi-hugepage buffer coalescing")
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>    io_uring/rsrc.c | 8 +++++++-
>>>>    io_uring/rsrc.h | 1 +
>>>>    2 files changed, 8 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>>> index e83a294c718b..5132f8df600f 100644
>>>> --- a/io_uring/rsrc.c
>>>> +++ b/io_uring/rsrc.c
>>>> @@ -734,6 +734,8 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
>>>>        data->nr_pages_mid = folio_nr_pages(folio);
>>>>        data->folio_shift = folio_shift(folio);
>>>> +    data->first_page_offset = page_array[0] - compound_head(page_array[0]);
>>>> +    data->first_page_offset <<= PAGE_SHIFT;
>>>
>>> Would that also cover when we have something like
>>>
>>> nr_pages = 4
>>> pages[0] = folio_page(folio, 1);
>>> pages[1] = folio_page(folio, 2);
>>> pages[2] = folio_page(folio2, 1);
>>> pages[3] = folio_page(folio2, 2);
>>>
>>> Note that we can create all kinds of crazy partially-mapped THP layouts using VMAs.
>>
>> It'll see that pages[2] is not the first page of folio2
>> and return that it can't be coalesced
>>
>> if (/* ... */ || folio_page_idx(folio, page_array[i]) != 0)
>>     return false;
> 
> Ah okay, that makes sense.
> 
> It might be clearer at some point to coalesce folio ranges (e.g., folio,idx,len) instead, representing them in a different temporary structure.

It could, but it needs a fast way to apply an arbitrary offset
and iov_iter_advance() is not exactly fast, especially so for a
long bvec array. That's why it keeps all segments of the same
length (apart from first/last).

-- 
Pavel Begunkov


