Return-Path: <io-uring+bounces-7303-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1373AA757A4
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 20:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88AC43ABC70
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 19:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 493B21C5D7E;
	Sat, 29 Mar 2025 19:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mbe2UgFK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E8F1A5BAE
	for <io-uring@vger.kernel.org>; Sat, 29 Mar 2025 19:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743275230; cv=none; b=CZGk4+AAA2qa67jZmZRI3d+rOIKm37a7WBKPcf0rMmiSgwaz4zS7OUNcomxsNwp9J4KLjytp9TAyFQBB+CjOCnpuW/H3pca/nZ6IsYK8S04PfnGprCAcCc9J4KRDXlN65EvUP14+jogauyHCbPip+xojKKrbQiCRHBOHGFk00XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743275230; c=relaxed/simple;
	bh=CPIt57KTbw48U5UWIhC/4Sj7Kxrgg20tW/7JGwREow0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kXPZaZlxF/Nc+X6qq7sl1n8vsmKp2p811cQhK/BpeLs+6W6exKgJfwhahhSoETpCUDKnChsHZm3B/DZU4yvSu16ECBy3qi9n7QCenTLnpnAva+kJL+1OrjsVzhHW0G9mvfyXjOWZgwc+rYpXC186o8FccsAxuaUEhMYFeo6lvB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mbe2UgFK; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3d59c8f0979so12042225ab.0
        for <io-uring@vger.kernel.org>; Sat, 29 Mar 2025 12:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743275226; x=1743880026; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PaGHXcdYFnrdjAPBt/dtHNMzVVLvDagzoTGvwSBAWXQ=;
        b=mbe2UgFKItYPtsZr9HBaL9Uj1UCCu4KekLD64Hk3kDAJJlhGKtD6sbIR45JCx0HHJG
         P6LLPbtCqdMR17SfXNAJzJUe1wmvajIz6uI8v3LimwCwtcSefEHlPCgnPb6I3A37T6NZ
         jsKl/cwPG3vWyZaZBugV1mY8TtHnP6/Ne0pr64ecFbqRg+nEotAjEVUnGi4cSiOhjS3R
         FVCg7SF8jn8wjfj6Y3KaUBAXX778e2PmUPspQLbaKTW3X2FAD/YJFYvJNnfFAWykUuIv
         CWHOYNxkYi/tquhi/GHKeZccDhcJd+6J+zU0w/U4gauldQjD/MWcKDWsfhUB7GcaPYFs
         JRcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743275226; x=1743880026;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PaGHXcdYFnrdjAPBt/dtHNMzVVLvDagzoTGvwSBAWXQ=;
        b=ePeHLJTpRUFbMLseX9YxOcfTEnU0kZ7vKvZKskQzxFz0SIepjvPsI/tJGTWQ/ZF+ND
         ptKEBk8DjNSvFRepjF6pCOuq8S1yO31iit2shg0fq8MTLycPnXJrZshz/wDLRu/AZFrT
         NTJfXx+K4epPpu3xsBq5C+cJzwcEkro4ki9+WbiKfgIPN3jhzY0lcwwDF/E15vzDFNBn
         bnJdyTJ532yjMWIoS72Oymy49AMLmxf8K7gUHqxZJ4EkPDwjonLOPJg6ZtwBQ/XKc9wb
         tPliOh1clYoI+9YXCG7kNFasnqxx5KIbxMObN/21pBxt+dYWAIa5QSlBjCBZSVj/C8wt
         bqnQ==
X-Gm-Message-State: AOJu0Yy12r3ZN4glVB31UXCdia8beeXJLo7huiqDDFXneKTGxqbzo7+G
	LXSslKEy1GgdPVrQJYNd44VjNwsDCY/DufWqrfmdEPBE1Ewsy0OAzCKgKz729MY=
X-Gm-Gg: ASbGncsPLPabtqGE3gVyP4GAJB7xm0C20sUlaxmD+przpwmzsa6RsUkgRFMla8icelJ
	0o8YpZpSkRcaqnO8+NLcTZI7cpUA7l7ki7jKKig893+8YYSA9p/tuslET5vioROxbAJtVcNc6j6
	MKS88PgZuAxWQ0PkFrvwC2q/AJ3BagBotGJwjl8ermULy19maW2Q/mgSPQR+5mKX7cb2L6hx2kT
	9skPO0701X+VIsHjCAW2rhpTtfEgnC5g2FzXurkPUN4EpVWQITlAh3mEoVd9lGMtjsbcEHL4JiK
	GB1394KZhJcJz3fK3Wtqqv59rg/JGYous/9i/2G0Ng==
X-Google-Smtp-Source: AGHT+IGGI5rUj29WJPXqMbVotuqKmnVzBYiicrC4WVNgcPFELxFvIKEqhvm7OfHT2pS0TayTuv9AmA==
X-Received: by 2002:a05:6e02:4401:20b0:3d2:af0b:6e2a with SMTP id e9e14a558f8ab-3d5d6c832eamr47389485ab.5.1743275226428;
        Sat, 29 Mar 2025 12:07:06 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f46489e032sm1007193173.124.2025.03.29.12.07.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Mar 2025 12:07:05 -0700 (PDT)
Message-ID: <9d8f1460-6317-4e8a-ba90-53e35b41f235@kernel.dk>
Date: Sat, 29 Mar 2025 13:07:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/wq: avoid indirect do_work/free_work calls
To: Caleb Sander Mateos <csander@purestorage.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250329161527.3281314-1-csander@purestorage.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250329161527.3281314-1-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/29/25 10:15 AM, Caleb Sander Mateos wrote:
> struct io_wq stores do_work and free_work function pointers which are
> called on each work item. But these function pointers are always set to
> io_wq_submit_work and io_wq_free_work, respectively. So remove these
> function pointers and just call the functions directly.

Was going to say that the indirect call here is not something
I'd be worried about in terms of performance, but it's also kind of
pointless to have them when we have just the single do_work/free_work
callback. And hence it'd reduce the struct footprint, which is always
useful. So yeah, I do think the change makes sense.

-- 
Jens Axboe

