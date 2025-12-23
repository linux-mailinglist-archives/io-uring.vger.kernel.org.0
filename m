Return-Path: <io-uring+bounces-11290-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 36A3CCD8289
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 06:33:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E5B35301CC58
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 05:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A2752472A2;
	Tue, 23 Dec 2025 05:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YRS6qc7F"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com [209.85.215.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21A02E6CA8
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 05:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766467988; cv=none; b=Q3QsxuA1ACIoN8snt4Gz0xNfB+pCHzcILiPTUT7oaekSKC7Moga0uxybIs1mkG7s2NwY0ru/cno1pSLSE57H/QAOIZe4GHuUV+uN3QJOVWD0F7GPEpcKuXx1Ah6Mp1AuNJaUyiWPzevOKx5k1y4Va6ix24wphfv1IrZ4PIiocJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766467988; c=relaxed/simple;
	bh=NqkuKEROb/OmRVYRZgeOKw/Kls8Un9PKgqEiKcwkGnk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BAtkIP0l8dZoRjDcwluDTBZUg7UmJ//Y9OUWj8sKddt+gIlnRrK+HPEJIMwR3XqU2pZDjDXZrAwXX0m3KcjvfkjEv7CI81ZkfedGlMEBCAeHhdXHw5EKtFGSYOaW+L8CK2HQ6466ZKGKl3QAbAeOfUETM2VFU4cAUAF3eRYDA/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YRS6qc7F; arc=none smtp.client-ip=209.85.215.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f194.google.com with SMTP id 41be03b00d2f7-c0c24d0f4ceso2669491a12.1
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 21:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766467986; x=1767072786; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NqkuKEROb/OmRVYRZgeOKw/Kls8Un9PKgqEiKcwkGnk=;
        b=YRS6qc7FN4EtduWa68ZXt023TSQiTMXdK7qVlD+eqY53wkWAc89L+baCoLPtatoQNV
         nRV1kqExU4x0Kq/7nLf23qk+jbHPJl1ohW+d6khZJaUUSHKu7UEyHFcuAq3mVyZfVs2E
         mTs3xHvhMuxCjBsNRAzGXzVyQIm1hFrGsZkIVSNA3tnwpvXfk5MxMCrp1htANa4luD++
         f1I0ejIHnRULvDlp6uuawM2q3dtIwL6o3ClXqX/3lAzNiyqtoHm6/1AckOVeDCqzznAA
         cvLnp8ljOlrbS/ahjo6lewbqz/tmL6Gf/oJ28nvKtLYo97aUsLsSQU7wgUM6LnBxyHtH
         UOVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766467986; x=1767072786;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NqkuKEROb/OmRVYRZgeOKw/Kls8Un9PKgqEiKcwkGnk=;
        b=BTIUn/VkVv5KQEbW2ws4knWpblccRVShI0HuB3IakUqER/CC72N6i7C6SgXa633aS2
         1IsQyX9hs2ACKGG+0nKj1LbUaIzeN4Wf6KdmXLaJMFgP+aj6qEfJoZi7b0Pla0g0kcC3
         BbQoIZcKziAOfmsZJk3Q/r0kDHHuJvvlRBBs9lrFCAEMFHGpMq4UWzoQtC8wOCcKldtt
         fE07xa4jiowfH3emmpeY1t9N8wEd5sXDDiG+W1Yq4BcTxGiqM2MkuGsjMmqhyeccjlkf
         R5aaOFEoJMK1tfreBr7IrP5CVzFJijPUNuO2XVKyR0FqbpfDQyZrrMxx581uOePABTt3
         +/Aw==
X-Forwarded-Encrypted: i=1; AJvYcCUlNcbHVHTTG+a7wscSkScLABIFJSvgOydw80jlJ/IJXf+5P2GsGrP7e0a9jUJCbWuiOV7x5ZT3Sg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxEATwVV1eLBMGNa+mghrZin9XnAOFgeEtuF+BAJkUq9jaLLdRe
	2SClslItlbSFgzD9vCxsWt/2eS2SpYRgn3K/5a3b4KRw8vr8PUNIpzVj
X-Gm-Gg: AY/fxX6YByQweQXiRU6pgdyXJcIQi9gAAVYXhPWpTQYkfgvWzwRr4eGTWb5awN/5dJN
	S5KwO+yow7fdt2jEQPN8vmU6ngUuXYhjNgcfsN/uYwuqw1tNuFokCY39Y3mMUI1sJ1cCzCVbH1P
	M+xrAh4Fvi9r0HhgLOvzGKYSCDZMPfwR6oEINuTOm7dYf6jIPdntvtUX2E/kO0z6zljyzLeoKup
	Qd+THZC2V/x4T8mwMm96FdbH5yzrtqATkfugB6ZyqPhwXR3nd2m9r+J5XHU0Lp/Y46zWypD3coo
	fzzLV1xVdkpaTNm7QzLLMnkryzSqs5ChTo+QGfN6Du1k3HABINRegYbXlsVycWBXfufaukOeh7i
	GU7fm91IjnJp1/AsEcoY/vbkkHTtWQPrI0xrBdvUDU6//j/Rabb92QzGB9Z1qDWrTrwGXLSL2mr
	3WDVuQBBzQcU7t97da1jxlnYmbCaCAVpTAqEVQ3TwgznKnct73RkA4T7FTtU6dBh9X
X-Google-Smtp-Source: AGHT+IG5Qf4dCPxqVYyhhZiZ2cPZHWZcc5Jl8Dom3Sf+VbFYEbzUaslYB9RlXBdrrGXOm7O8E9bw2A==
X-Received: by 2002:a05:7301:1a12:b0:2a4:3593:ddd6 with SMTP id 5a478bee46e88-2b05ebb6038mr11158060eec.3.1766467986000;
        Mon, 22 Dec 2025 21:33:06 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217243bbe3sm54002618c88.0.2025.12.22.21.33.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:33:05 -0800 (PST)
Message-ID: <12bb96b6-1e2e-4f53-b4ea-1fae2500aa21@gmail.com>
Date: Mon, 22 Dec 2025 21:33:04 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/11] fs: exit early in generic_update_time when there is
 no work
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
 <20251223003756.409543-4-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> Exit early if no attributes are to be updated, to avoid a spurious call
> to __mark_inode_dirty which can turn into a fairly expensive no-op due to
> the extra checks and locking.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Jan Kara<jack@suse.cz>
> Reviewed-by: Jeff Layton<jlayton@kernel.org>


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck



