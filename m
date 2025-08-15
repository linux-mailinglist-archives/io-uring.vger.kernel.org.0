Return-Path: <io-uring+bounces-8982-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88374B285A4
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 20:13:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18EE8168F9B
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 18:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B074304984;
	Fri, 15 Aug 2025 18:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hyri/WCF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311042F9C3B;
	Fri, 15 Aug 2025 18:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755281596; cv=none; b=OBgXKimaLcGssZ3wC97CLr/EyQDk5zSVssliNFniFURaZObRXrrCFQZ/PIkiX/orhw4BvYZrrHl63LRc3vabCVX9Ar51+mN0J97nMZh5IvAd11srMZg4I6hHvCSbW7Bg75vKfRoLp5WVvEo4izfYyVCHJOFYZbFuqxiiBmI7RNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755281596; c=relaxed/simple;
	bh=fFYyh5J/EOcbKjLUREgW3XR+vjT/ijh4iRwnyj4BFpc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=oOzyZFs4hrChSL5Gm3O5w3F8DzdVmvNFN8apN8x+qeMPJFkwLDozMPKEKMAxneUKnfDPCPlyStRGjhp923IusjG3mYJAvycV2NezI7155N4p+Zn3aldjv/iZ0UTcXiTCWZQ1ogkalZ/5b880rrwdF7IAzouJtLDfinmm5UlWy3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hyri/WCF; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-24457f47492so15255455ad.0;
        Fri, 15 Aug 2025 11:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755281594; x=1755886394; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JyFLdgUQkPQ1EBi1OP2pK+ChQ9j+YhjltNfXhrruJdc=;
        b=Hyri/WCFQASc5sPmRX3r/WEdq+EgDNCfaoqN0KTfERAzeB/4xdEgAdlmYfuUO1CXC5
         JHSsFlYKekAzcUIlBVt3/YteOpNOnSblhbfWeCiaT8tWUs/oHq96i1wPqNhhagA3cy9G
         Uz0gpmcQGOCi+/7kP0BayokdxOFJsiCTJcocw/xm7TU9zduYryHbTE54ldiO9zBN1uFk
         /Tz4q8uuE853RszzUe1Jisb/DvacymAIEqyydOn5vk7j1ThAW7UK49WIb3BmsrbSuG+P
         yyCV6eXN0PLG0X7ivBJVIa2ZHRQKNV/A/bwPBBA1YnkQKbLsMp+OZGr0wXTMfl5IW7Dp
         uJiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755281594; x=1755886394;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JyFLdgUQkPQ1EBi1OP2pK+ChQ9j+YhjltNfXhrruJdc=;
        b=YKiDVK7wcsV20lic1Aodh5hmXw4e4Rd9+E5BvyEX7HVjRSZG0yVVCfIaiRDGMBJ9JU
         e5RR+MW//vCAcve5WUHaEy9sf5VKXFIUoPP72SuIchR6jBnWk+XIvJjPZWzppXaIMtr8
         +JKp+gjY+bQzppOZAwApbo7CG6H0qrjeNeVmVOsKCj6NyBci8tfFvVhe16iuCzt0gDtl
         8ReJzQZJJLtJV2bEz62wbjWrsdNO5jIjsd1VWWBA9y2OkmJCG01D38vzSPwJ6nJTxTVE
         kpFJn/s8pHsob8eC7gDW/ckE0BNW4aIsgkS+eWxWPaY5ISVb8RPe/3U0jfB8Ib/ymsD1
         bULQ==
X-Forwarded-Encrypted: i=1; AJvYcCUoxCEPxS2AiLALX+swgEYgyalGNrL24mMwtFs+IBZMgeEIEINB2zrRwWLdflZJEUG3fCsrxLCaQrGc@vger.kernel.org, AJvYcCVhG1W/o/QlhTxxYIwsrVnv6ybgVhD0zQUxUybMl+yWxsh2vaYEz5Ohx3Uxrzsk4vvrzP2DVQwWW+0h9SJX@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5zwNbZkdRH/w0PjCsdl9984d0Uw8TvFBwhfxLIQ0ko8+vFf8k
	GQcOcYTd3UXCbtgbIv5cjaCCBgp0G6d0T9hBb33jfNgkPrmj+j1xoce7
X-Gm-Gg: ASbGncsKQ1cFN44KPw/cwRIeeK9MwiRYq9KE+CrReOk2ODXxT1korHaSmeDiJHYIvu1
	adez26F7WGkBE0rT99aiKuKTt3qqCDntrhxuGd5xir0kZZt6E2vc4qTshLWk4pjJS2ZHBF3/54M
	jWzqbDfW8IaunHYJbDT3w0CPR+fDa+osc+aNkySJQzXDtxQWF3VS+fl5FaE5R/k6IJEKq3epa2C
	cIqowEVVNhVmwGZdzypDkO7hCVTj0ALh8HJTUg3YWuUpvC8dAOCoY41enpGl2O0/yikgYi+6Vgp
	8p7muhQi5+9EhcbPvYnfLlFeRxYFV/10kF7toBzUiHz/KQroj+DfBhrJmODlHa4vF5ur9E6zQ5/
	HhxODHoZthVj/rR0qYV9jJTIYGQ==
X-Google-Smtp-Source: AGHT+IHhLAqcn6t3IKYb9FoYhIYSVfavKpTay3V9ds/iGSURETjrjA8ktGyW8ESLrAQPBiPxojQ7nQ==
X-Received: by 2002:a17:902:e80a:b0:240:63a9:30c9 with SMTP id d9443c01a7336-2446d71ebadmr46619365ad.17.1755281594292;
        Fri, 15 Aug 2025 11:13:14 -0700 (PDT)
Received: from localhost ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446cb07105sm18948305ad.55.2025.08.15.11.13.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Aug 2025 11:13:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 15 Aug 2025 12:17:44 -0600
Message-Id: <DC37HOOZSBJA.3ADYC1VKXSHJ6@gmail.com>
Cc: <io-uring@vger.kernel.org>, <axboe@kernel.dk>,
 <linux-fsdevel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
 <brauner@kernel.org>, <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 1/6] fhandle: create helper for name_to_handle_at(2)
From: "Thomas Bertschinger" <tahbertschinger@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>
X-Mailer: aerc 0.20.1-0-g2ecb8770224a-dirty
References: <20250814235431.995876-1-tahbertschinger@gmail.com>
 <20250814235431.995876-2-tahbertschinger@gmail.com>
 <CAOQ4uxhPMOoJEK_nVn-fyBX+TzE_EJBb8wmXPg2ZCWfyEA+utQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxhPMOoJEK_nVn-fyBX+TzE_EJBb8wmXPg2ZCWfyEA+utQ@mail.gmail.com>

On Fri Aug 15, 2025 at 4:21 AM MDT, Amir Goldstein wrote:
> On Fri, Aug 15, 2025 at 1:51=E2=80=AFAM Thomas Bertschinger
> <tahbertschinger@gmail.com> wrote:
>> +/*
>> + * fs/fhandle.c
>> + */
>> +long do_name_to_handle_at(int dfd, const char __user *name,
>> +                         struct file_handle __user *handle,
>> +                         void __user *mnt_id, int flag, int lookup_flag=
s);
>
> I really dislike do_XXX() helpers because we use them interchangeably
> sometimes to wrap vfs_XXX() helpers and sometimes the other way around,
> so exporting them in the vfs internal interface is a very bad pattern IMO=
.
>
> io_uring has a common pattern that requires a helper with all the syscall
> args and for that purpose, it uses do_renameat2(), do_unlinkat(), ...
>
> I would much rather that we stop this pattern and start with following
> the do_sys_XXX() pattern as in the do_sys_ftruncate() helper.
>
> Lucky for us, you just renamed the confusing helper named
> do_sys_name_to_handle(), so you are free to reuse this name
> (+ _at) in a non confusing placement.
>
> Thanks,
> Amir.

That makes sense, I can adjust it like that in v2. Thanks!

