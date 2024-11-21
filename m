Return-Path: <io-uring+bounces-4931-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F26C9D5000
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 16:45:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 90141B21D72
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 15:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3481155C98;
	Thu, 21 Nov 2024 15:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YcfmLjbD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B0013E898;
	Thu, 21 Nov 2024 15:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732203890; cv=none; b=NNMmloW3URj93Gw6Z8wqnvuGv1AxzIjAhofcbgRt79YLs2ZYIhSEwqBtu+Qlo9H/0oYkpVigMfwJ5Vq8lPdTMybfSN4jJwPlpS3OaZaclTpGE3L4x+RRQMKV/ZGMcbnG/NrZdZxpI0BYEdMGyvSuXeTFvs/ZWdEGNxHJSBEpGak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732203890; c=relaxed/simple;
	bh=MB6iJnnXYaZmNl56XT3EwoAa/w2SBxfGpUrAsPhuyX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JlpSFEMpVb995iKYZ2OD3Oq7gAM2np9dUX0scdIoPu7+HQBwQOwgRzWsDU1KwuyGkK1qLTUjNVGuM8Vh2N2qN6WcbH057oInP+XQpyf5BaNgP0wrOHBMTniBuE/5qLhMP/ZdXl5lUiI61CpoFCYxDjmy8iNj3Oyohq8d/F+slLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YcfmLjbD; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-53da353eb2eso1763386e87.3;
        Thu, 21 Nov 2024 07:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732203887; x=1732808687; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Yq70YJzrFfkaT6vO9+6QOQ5rfwZ7sR/Fpz34vhs1TzQ=;
        b=YcfmLjbDeg66naza7X6STJigEBriur9xptPGujJR+V3z6VB4JHvuTY8yLxORIEIV4s
         U9RYnrj3vrJd/zgVFI3KVRDqZ+7RqQgz+JfUEDiRKGDgZ7GxizBQno/6qdlVuPGdey9b
         E1qZcZ/5vs0F1LeGD69q+asMGfw5Gz/JmwkHp+BWee5piVG4W0qCuyl/EDnSqRy2h7ON
         hJzSkiKfQgXBOmOd9pMkZJVwWHPWdeob/iclISYrbMKPo5F4saBlUI9sR0bu4l2ZyisV
         bBHX/6oZpVAjUeeAk3YrYUhkpGnxxeOmx+sM6PdO9HzfIa5KG9ftJmCjjh+RD0Sreszr
         sHuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732203887; x=1732808687;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yq70YJzrFfkaT6vO9+6QOQ5rfwZ7sR/Fpz34vhs1TzQ=;
        b=Xvdb35BOvkkK+32ZmA+uPRclcfqdGuMfPeYG/zxFb0QXjIo8IGRM5DwlyELSvvxw/n
         V3DW//cA/zAZaIP/cPBHdKBukkiD/AumqIaWygg3M6rIW+uukcQqlxKTyGjrrJCMlVj+
         uDi9xLtLWVb49fBYm+/o9u2k9lJEkOR4dbNxHdki0LcPixcbjBaqZ5RnQVCumFWgXASy
         qOs7VE1EKMFTkIjZm+S/XVk17/J/ZMLcY524snbhCrL0Rw0j3PijROcz3z7zod4cWBJL
         KaDE5QtWZiI2cgP0lKewUWLuP1BDUTZSsdJMpmsrpnmUXi6P+/es9KvWQD2dMYLqP22s
         RdSg==
X-Forwarded-Encrypted: i=1; AJvYcCVUVi1YwvnhcO9JfK4cTqLFqj+RuIqkkBm9Fh8gQwVzVgiYqqfB1TD574vR2Y3Vgdj2LBrfMeDK5eOG4Q==@vger.kernel.org, AJvYcCWRikq9ntiwj4+3BKevlsUabH2W+AmMcdapDnKrVX0aifHQWwQzrm79zIOTebuuzR6A0c83t5uN70Zxg8omiQ==@vger.kernel.org, AJvYcCWc3ieakZ6cug5KHBvPyBn7cwERmYAsMdlHhVs7XoEo4FmImqOSJ6UBiJzJh78n+gEc9+h0+t9oYohyThk=@vger.kernel.org, AJvYcCXUebid6tj+qHDw5TgWM9fHGm7gCiXhRRNVXWpHkI4b4NMM5XRPA/6ZlTWTyQIrW5NQrCYPi7/+0Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyCQUO/PRY/nU2rTt9iCjdcPfGrcU1lB/fP5y8ibKhJTzuTJMXE
	vhOrRSRp5c+O29NAfYdo0kgpmSeaoTdMrEyAlHLt/cJpZHr9iZGm
X-Gm-Gg: ASbGnctCOFphGJpIgpIaA0dz00SawXrx0fKhgi5kT3LPuZqc9dUY5KRdH/etO+NlkSD
	rG9crNq9xT0ROi2MjLCq7CBxzkt1JQub0Cj8X/gV3x8YVvFcJUNrJSM0FenB2lcXpl/oMaFaPvr
	uD7N2/7jCEzbrYNRyh/hShypwLMCT7Tuw89PSqPLSrRxnvyfGQEcfTVCN3TvJPCfX6G2UMF4afv
	H+BP2Qp0ZsyB/UZpYOQrggsOT/rSGZOX+bAy79bULyIjpXBYVKDDdEeugZZCQ==
X-Google-Smtp-Source: AGHT+IF++NRQF74gXAH6xM1W4Qh3AQIH8KSN5zEQe3RTf9TGDltr4dR/aWa+g/x4zzyWxju6+0KAMw==
X-Received: by 2002:a05:6512:1195:b0:535:6a34:b8c3 with SMTP id 2adb3069b0e04-53dc13230b4mr6167738e87.5.1732203886812;
        Thu, 21 Nov 2024 07:44:46 -0800 (PST)
Received: from [192.168.42.120] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f43801f5sm93964866b.190.2024.11.21.07.44.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 07:44:46 -0800 (PST)
Message-ID: <506ca9ff-40c2-49eb-bcc3-e1735a4f4cd9@gmail.com>
Date: Thu, 21 Nov 2024 15:45:37 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
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
 <2a98aa33-121b-46ed-b4ae-e4049179819a@gmail.com>
 <20241121085935.GA3851@green245>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241121085935.GA3851@green245>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/24 08:59, Anuj Gupta wrote:
> On Mon, Nov 18, 2024 at 04:59:22PM +0000, Pavel Begunkov wrote:
>> On 11/18/24 12:50, Christoph Hellwig wrote:
>>> On Sat, Nov 16, 2024 at 12:32:25AM +0000, Pavel Begunkov wrote:
...
>> Do we have technical arguments against the direction in the last
>> suggestion? It's extendible and _very_ simple. The entire (generic)
>> handling for the bitmask approach for this set would be sth like:
>>
>> struct sqe {
>> 	u64 attr_type_mask;
>> 	u64 attr_ptr;
>> };
>> if (sqe->attr_type_mask) {
>> 	if (sqe->attr_type_mask != TYPE_PI)
>> 		return -EINVAL;
>>
>> 	struct uapi_pi_structure pi;
>> 	copy_from_user(&pi, sqe->attr_ptr, sizeof(pi));
>> 	hanlde_pi(&pi);
>> }
>>
>> And the user side:
>>
>> struct uapi_pi_structure pi = { ... };
>> sqe->attr_ptr = &pi;
>> sqe->attr_type_mask = TYPE_PI;
>>
> 
> How about using this, but also have the ability to keep PI inline.
> Attributes added down the line can take one of these options:
> 1. If available space in SQE/SQE128 is sufficient for keeping attribute
> fields, one can choose to keep them inline and introduce a TYPE_XYZ_INLINE
> attribute flag.
> 2. If the available space is not sufficient, pass the attribute information
> as pointer and introduce a TYPE_XYZ attribute flag.
> 3. One can choose to support a attribute via both pointer and inline scheme.
> The pointer scheme can help with scenarios where user wants to avoid SQE128
> for whatever reasons (e.g. mixed workload).

Right, the idea would work. It'd need to be not type specific but
rather a separate flag covering all attributes of a request, though.
IOW, either all of them are in user memory or all optimised. We probably
don't have a good place for a flag, but then you can just chip away a
bit from attr_type_mask as you're doing for INLINE.

enum {
	TYPE_PI = 1,
	...
	TYPE_FLAG_INLINE = 1 << 63,
};

// sqe->attr_type_mask = TYPE_PI | TYPE_FLAG_INLINE;

Another question is whether it's better to use SQE or another mapping
like reg-wait thing does. My suggestion is, send it without the INLINE
optimisation targeting 6.14 (I assume block bits are sorted?). We'll
figure that optimisation separately and target the same release, there
is plenty of time for that.

-- 
Pavel Begunkov

