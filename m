Return-Path: <io-uring+bounces-4777-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A9DE9D1699
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 17:58:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AC932838FC
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 16:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFE0F197531;
	Mon, 18 Nov 2024 16:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iM5TB188"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DA91BD9F0;
	Mon, 18 Nov 2024 16:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731949117; cv=none; b=h172OuzTMpkI8M1w/5K8/lpUDjqpzXNJZzi5qktt23qFaLqt9K5WQpURkVIbcdP2uWbZFSjK9rgXGBC+4gCmqAsWCxGd6zxQ87MrLlpAYGVh83zleiNgqStFsa36R/0L2ERJoCvqmF9uqvcU6vHN5Lkc/uCIN+xbzIygBTQkUFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731949117; c=relaxed/simple;
	bh=kzR5oO2YyWn3BRt6e7jTLFGcAaVEnhwT5nGbS7yaZDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QnnkWg9zo+WepT/dWn+B5SeGponzy4jJaiRNtwzt3frmPR3M7Z+BEif77M+qi3uYZlZS7kjupidfxDZDFXHX3UnGh3gN1N4nNdlCf4ej7ZX0bHeipZtSfRGOzWTAjmHy+VtsaYjV3gewNyTO+g4WJNQ4gXExgHE/QmDfcvAhmVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iM5TB188; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5cb15b84544so3042368a12.2;
        Mon, 18 Nov 2024 08:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731949114; x=1732553914; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wSa4AiSUQT4EIzACqKoBsLT6b9aJkO4XWmWdzOpmUFk=;
        b=iM5TB188EIqANjZ1Skni6dgA5qEWTODFLUvOZemC3bPhS0hkpm5mYItTE1KW9hJXCP
         OSo+Og16Z45w/M0bYoVMyYniIC7y76zLwvMK37aXeVF6ANXuemUHX0CLAP9GE5Qnx9Xh
         adYex51cht2Gf1Y377u4/Co7AYvbHvLe2B9qGEWZvGrj4+NVOTAD1F9L2V+07ryH97iV
         QEUuUO17WkSOpBRizJPzt3JfuIV5tiQq0qFnSL/j8I2L0LpmYZYPxH2Lu33KtV71mTHV
         xJ/byElwj4mICdi5mT3aGZDZ66IVj0ibdKAwLfkIHXNkfI4xnImc/iXQtrTRHpmtQw0T
         phdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731949114; x=1732553914;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wSa4AiSUQT4EIzACqKoBsLT6b9aJkO4XWmWdzOpmUFk=;
        b=Fare21DR9dpWxU+NjAnVXeOZjl4w+ssNn9Iulr75bPYDWMAUOHnbKAkyXWTwQowiZt
         gdSYkKSPWyKEqxu8qbD9KLFfVey1PgAoEITRYJvr2b8NSpyS/2KDX20i/sga6R3embr2
         sIH4tU2M1E86KkGikM6ukal9LdlmJTAg0ZDiyCbXVEwKjaDPjEto3yVuTvawraqInPE5
         zGpkme3xYomOBJk1CVF7NBYRKqdROwUH5eFS4cNQy4hV+/kurFHOiF4qY12NC9yUZD1U
         MwFOIMF01wZmB5L4uWOIGoHGtvLDojVtgxqKMZ1plaOxeLAfyOjmTU/0xHmpaCBe/anM
         Yj0g==
X-Forwarded-Encrypted: i=1; AJvYcCV6+h/DpGZxB1IqKa/TARiiGXnxlinPpRp29KQtUGvI+2pZriPP7k8w9m7VYEOxJ04Z8yjIF+aKNg==@vger.kernel.org, AJvYcCVbRD8KAf5ihR1KFdF+YJAvzyWV1uanXMonWcI+g8PPZWPEWmt+Sl9Ia6ulJqMrPJaOUegOGq8Pr0I/5M8kJA==@vger.kernel.org, AJvYcCXKEzQw4tEY33Jiw5A0PDPAQ4ZwJtG8JHt/dC8o+2tgiFOBUlyTL2013G8DLZF8ofmiqhLQ3zOaamNmHZI=@vger.kernel.org, AJvYcCXUoZPnLS9By5bY7FSJkjig8DYTrgqkbdCBnxrUED0fGq2JEHNHeWAytJ8MggxyrtrQ0GGsxsH8EwdLMQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzC/S7zyHbzhOuANVbLNLqC5foiYX8BGDc89a1JdFqsCUhihwEs
	f/n2b44pzcDysNwA8kBFB+VzzG9cHzFG+fkX9EObxXk2RBhoSnsG
X-Google-Smtp-Source: AGHT+IH52mNHQGeEuqVdr1cSbraHrFN8r876XTWARB223O2IQYjwJD8dVGvodh77iQ1knokoJYKsEw==
X-Received: by 2002:a17:907:7f88:b0:a9a:7f84:93e3 with SMTP id a640c23a62f3a-aa48341a1c8mr1260995866b.14.1731949114149;
        Mon, 18 Nov 2024 08:58:34 -0800 (PST)
Received: from [192.168.42.187] (82-132-219-237.dab.02.net. [82.132.219.237])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e048f12sm557010566b.173.2024.11.18.08.58.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2024 08:58:33 -0800 (PST)
Message-ID: <2a98aa33-121b-46ed-b4ae-e4049179819a@gmail.com>
Date: Mon, 18 Nov 2024 16:59:22 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
 martin.petersen@oracle.com, anuj1072538@gmail.com, brauner@kernel.org,
 jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241114104517.51726-1-anuj20.g@samsung.com>
 <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com>
 <20241114104517.51726-7-anuj20.g@samsung.com>
 <c622ee8c-82f0-44d4-99da-91357af7ecac@gmail.com>
 <b61e1bfb-a410-4f5f-949d-a56f2d5f7791@gmail.com>
 <20241118125029.GB27505@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241118125029.GB27505@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/24 12:50, Christoph Hellwig wrote:
> On Sat, Nov 16, 2024 at 12:32:25AM +0000, Pavel Begunkov wrote:
>> We can also reuse your idea from your previous iterations and
>> use the bitmap to list all attributes. Then preamble and
>> the explicit attr_type field are not needed, type checking
>> in the loop is removed and packing is better. And just
>> by looking at the map we can calculate the size of the
>> array and remove all size checks in the loop.
> 
> Can we please stop overdesigning the f**k out of this?  Really,

Please stop it, it doesn't add weight to your argument. The design
requirement has never changed, at least not during this patchset
iterations.

> either we're fine using the space in the extended SQE, or
> we're fine using a separate opcode, or if we really have to just
> make it uring_cmd.  But stop making thing being extensible for
> the sake of being extensible.

It's asked to be extendible because there is a good chance it'll need to
be extended, and no, I'm not suggesting anyone to implement the entire
thing, only PI bits is fine.

And no, it doesn't have to be "this or that" while there are other
options suggested for consideration. And the problem with the SQE128
option is not even about SQE128 but how it's placed inside, i.e.
at a fixed spot.

Do we have technical arguments against the direction in the last
suggestion? It's extendible and _very_ simple. The entire (generic)
handling for the bitmask approach for this set would be sth like:

struct sqe {
	u64 attr_type_mask;
	u64 attr_ptr;
};
if (sqe->attr_type_mask) {
	if (sqe->attr_type_mask != TYPE_PI)
		return -EINVAL;

	struct uapi_pi_structure pi;
	copy_from_user(&pi, sqe->attr_ptr, sizeof(pi));
	hanlde_pi(&pi);
}

And the user side:

struct uapi_pi_structure pi = { ... };
sqe->attr_ptr = &pi;
sqe->attr_type_mask = TYPE_PI;

-- 
Pavel Begunkov

