Return-Path: <io-uring+bounces-11292-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C6E40CD82C0
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 06:36:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 84C65301CDA8
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 05:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 213FB2F3C2A;
	Tue, 23 Dec 2025 05:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ung45Q84"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462F42F25F1
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 05:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766468172; cv=none; b=KP5Xdc+bY3DYkwbRtEYJePzJZiS4QdwnWFmUN7sVUDMlczTH41RYmOuCOcCmxZMmiNwAXs6s6AWqcnJpGotQohQMFAW6MlTo0gxL8I0/N5Q9aVltN6PafBclNGcGFYwvsmhHeyggImH7Gbxkoc9PCey0K7kVwkPom0u0tOJfwb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766468172; c=relaxed/simple;
	bh=lW+UmIWRSVZ7zpivjjDN2RAk8y2uECMzZoBmWD3afKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CqRfc5Em9OQDvMJ10+suYMjPgsSttdDCyEA1LFAYHB/whnLa/lNjpir36vZNB+hUn2JiCwG4xrX8DYIfJgTNIK9e3DBRN9Wz7SQuIe1cC8KwENBCB7yP7DpeOXZJrYiKr/Ow/BgX0iOEx4eup8SE+5WrGAjGY9blJyGiIRixMG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ung45Q84; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-34c2f52585fso3992469a91.1
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 21:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766468169; x=1767072969; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lW+UmIWRSVZ7zpivjjDN2RAk8y2uECMzZoBmWD3afKc=;
        b=Ung45Q84NKJpgXUpj6V9c/ed39FtjE6rEaUqQWkJJFS7fjSzXwil3mKYAY6k0P8R9Z
         ddtgTfoZNL09/7vdeIMFC9JYApmDKSVclj15wMPBUSYzvYzI2V1K6y3+4OrBFi1YYL2i
         Ygo61aSI7PTM3LrIlLqoQR3YIwD47T+aDfeoHcsd1atowsBYoyrx6dnbVIVfEB/MalJF
         2NuWCA0r1bN8toEVguQoOSvqibnOTY8FjNDSkJ/sdULSEVFDzpcjyqioyPm4wEmXqrj1
         ilE8f7MJVCDOQnn9/KIYfxwD2zQKhMHjA+B/jiX/srEFwN0w8KKug3A4yAIpvlDCg4c+
         GzLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766468169; x=1767072969;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lW+UmIWRSVZ7zpivjjDN2RAk8y2uECMzZoBmWD3afKc=;
        b=xKYL91bXSB7VYl7NfjJ4cv0mFLB2xm/nB0aHZ4QiTZuTXzfsniSprfCmOe/1Kh1eBx
         dtvALZyFLsjZDR6uyRQUe1dX0g797rj0K7lFFyE9sOeeu+ulOK9vfaixSbtxB5z1DX0/
         94tdUTiRClByej99kH4/4xXGw1DNGag0peW3njoLwlT+wTlxc3obJFJ7oGQ2AEVP7W+Y
         LkiukHsYYzbe/noAkuiZS1WIfJ/+5pw1+JEkLeMfTTWKhGm87zzs/q90u6ICcxLmLKzm
         LXCTJ2qwanD6vqkwTPElv0J3yOnRTSRJAUCQelr9O1/Oqco6v2GsGCsRb+ed4IQDoOum
         R5Xg==
X-Forwarded-Encrypted: i=1; AJvYcCV2bHkYcO+ZOEXd6U2okGPjtrjDuHoXqkL9K+6znkzDKILu/tFcfKaf/NXBN1abuS/fm0t+mfJQgA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPSDt4qaa7XVd/FfYDTi+rZjwx0mv21vURmhTK0D4sjT/4gPIg
	n5ZuCCNb4mkB5qRfUpYAg1aIBJh3xw9YjE1unMvpdKW68cDA9kYpXrts
X-Gm-Gg: AY/fxX7qoFQ5k4J4wtr1xCu07gJQ9qpiX3IHWrLw4re3ETMsI8Mue6M0Q0gVfJPyNNJ
	5Y05+ff2QLqs7xQlziWdmN4otqG7Nr0sz9VVA9Jb+07d3X2FSQi13C0rV031qIseDMrIi+q+JT6
	hEEVnERyWe+K+CDPEkslNZBQBrzQP4niY8/qwjcC+TI6xzd7FyYTpK7Imtw72z2qCqfjgz/OAMA
	K1nakeWsd9hHEzafHfj1v2bmFhu9WIo3nyOWYXDEOBi9e1JdIASYClv56E1q0r0gEd+5s46IAby
	4nlcnQ8zK+UcrxoDNtzamCd16LmPqhBRvJlBsUlLZMZ00Qr0oLZjNuQ9XMAtSpOeEEZhuMXnbC2
	k9ce2d/Y5LWpDMYmjFX8/Z2zZ0o6AZtDmOo8W027v23loDbME68UKDBhJps5iTF7ZihNQo9P2WR
	EAWceuxz82PEUgitTmNkhas1Wd1g15ZOYQLMtLe9jzwC7QRU0otqR6LbLZ+nQXYbk/
X-Google-Smtp-Source: AGHT+IH379xsDZ0d7vjKdC6ERRiENfgRNsDKq+A1tK8cXdwsmB2ywvOol5d1N83fquxU7SkCjjJrLg==
X-Received: by 2002:a05:7022:3b8a:b0:11b:79f1:850 with SMTP id a92af1059eb24-121722b7f23mr14589383c88.14.1766468169469;
        Mon, 22 Dec 2025 21:36:09 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254ce49sm52556580c88.15.2025.12.22.21.36.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:36:09 -0800 (PST)
Message-ID: <e2d34cef-c0f4-4f27-91a0-439f85ed26b5@gmail.com>
Date: Mon, 22 Dec 2025 21:36:08 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] fs: return I_DIRTY_* and allow error returns from
 inode_update_timestamps
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
 Martin Brandenburg <martin@omnibond.com>, Carlos Maiolino <cem@kernel.org>,
 Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>,
 linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
 io-uring@vger.kernel.org, devel@lists.orangefs.org,
 linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
References: <20251223003756.409543-1-hch@lst.de>
 <20251223003756.409543-6-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> Change the inode_update_timestamps calling convention, so that instead
> of returning the updated flags that are only needed to calculate the
> I_DIRTY_* flags, return the I_DIRTY_* flags diretly in an argument, and
> reserve the return value to return an error code, which will be needed to
> support non-blocking timestamp updates.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck



