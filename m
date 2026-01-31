Return-Path: <io-uring+bounces-12003-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eFg0HuFYfWlDRgIAu9opvQ
	(envelope-from <io-uring+bounces-12003-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 31 Jan 2026 02:20:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DCAF2BFF1E
	for <lists+io-uring@lfdr.de>; Sat, 31 Jan 2026 02:20:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5EE81302A6D8
	for <lists+io-uring@lfdr.de>; Sat, 31 Jan 2026 01:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4143254B4;
	Sat, 31 Jan 2026 01:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C3XaXnr/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BAF2F616E
	for <io-uring@vger.kernel.org>; Sat, 31 Jan 2026 01:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769822416; cv=none; b=Qi5Sg+2Y/hnoJw2pIpjLFfTHXgK+MVDreSWsts20bQdg5dVC+wFcafkiMX+hlv4VSM1boBtLg7oe93gfdn3YJpDKc6xJCYX8zPA0p/8p/8XKuA0JbmYC2oJGtEA4TKjr3qI55XrsNVppz1JDPX7g+pfivvEXZfUNlUq+u6lWbc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769822416; c=relaxed/simple;
	bh=LqjG26iPcgUJUjdKHHQUCfcuvzKdnJ4bXKdhZ7B7/mk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qqSJXfBEHmWRI+5t9Czg8WsBMGxJzHYQOdOtb7UMHtxKykeBFvqJxGLfR6uXEqdY26CVCsCPFYvsnioB0mdYh2n5k/qmxp+tXzG5lKxCZ85thg4vS4l2n1y7If6IRh1CCytt23ayPTxk0q4t0ffaPs0yLNmDA1tdo7bTUkcZFL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C3XaXnr/; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b8863db032dso444219366b.0
        for <io-uring@vger.kernel.org>; Fri, 30 Jan 2026 17:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1769822413; x=1770427213; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X+Zsir5E/r34txHH39Th9Cb+s5GtaeVJrYm06jsRDB0=;
        b=C3XaXnr/FF6cIAzaxerJOqcXEXJ/Fa6W2MhMyzCzozQs3rRMXUq5fYZqLTp4bPNcmK
         We9PIwTdP8jJcxo6tdZH0nrPfK8Lyw4qDIhiJUSzb2Dhd+X1DfddffqbeH3kHrnGMurw
         Di5zx1SXZpi8IKYMnH1jXy7Asc/GxFcQBgMBY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769822413; x=1770427213;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X+Zsir5E/r34txHH39Th9Cb+s5GtaeVJrYm06jsRDB0=;
        b=LqXDExCebqrQBWTmYNDCWSPY5KpmsgarqDhLe7L76EKL6iYAXZS+3AtiikxtkT1yHt
         Ezmk+SUdI5aaZF6YjkY+24zOAfHTxl9q7STKVhmNu/kU9AsBVSmz0cttIbcR/BMc5fJ5
         CO2X84dLzRpRHCqCQ2NCz5V6igFjAWPss42Ys0QRDBFUxUJM/lG3etgBA9FI2ykSsL71
         ++YP5QFTmgNnyillPIi2hMel+vUmNMTMzK2IxI+LUtmfic3peV3U/HLYuy3rmhDnulrr
         h0es45rednCh5uYl18/NAwD9lJHGUqOUklvpvrVVRosu7H30r9uM6ACwsFRG3nxKP2nf
         aFUw==
X-Forwarded-Encrypted: i=1; AJvYcCUt+hdQ4TiKI1pvgjF/F1M2PJHAmyACowB81KpN0zynvUNEtATbudYuh7JMvSKFG4bap21EYG1cHw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwqTMS+C3JxzY+MV/F5XpHiTSKXPq+Bft0n+7KbvgwNQR5+ZUIZ
	SYZ3ntdLTc1StmXWiLvAHo+dEk2UeUnD1LrXj+9Gux0q+hED2vs5rO2mk6hjLzddfmLfmtDjt42
	w2dhAhr1PaA==
X-Gm-Gg: AZuq6aIqYkNuIa+6gEZ/jcHacyDzoIO/BUm/+XsvkcxdyZbAmcrOLLyU66Mf/FcPgLD
	6AJAulyjrSIefHJyISTRhWLtfiVi/o1Ye7mKS+3YsZORja/IH+xaxhBj62FjnXKzt+YXgFbDBPW
	CMmQbaoOgsO7PFgH8SWKf+56q7//mxMSV0Ec9ad7ewuHJ+abGig+ItXgsRdAfYJEk8vTpaj2g3o
	3UVB63x+MlnYlL42rmsBuiEJnpeV3FV9sd7eeMizfzlcBMqRGWM2GQv1aLPPkkoNyKlYbm+R1f8
	OBgdUoFexbKwW4TOZk7rm7yBLhbAYQbXwwzouscJQGT+01ZCWajwA09ilfr4TDAVBmeZpUI6Ua5
	LtU5vTfoOAX3ur5s6ZoyT5IAAvfV1fKSa6Za0816HvhFiH7KDQGUhWrEZQX7PfmWmjj+6fbV3G3
	nL1U/+8eFbdK5fminRvdNJi8aMXTDK3M9FemPAAfls3CdtPOO71SgSAhC8+sMa
X-Received: by 2002:a17:907:9608:b0:b8d:f6f1:e27a with SMTP id a640c23a62f3a-b8dff882467mr246378666b.65.1769822412898;
        Fri, 30 Jan 2026 17:20:12 -0800 (PST)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbf1c0213sm506198266b.48.2026.01.30.17.20.11
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jan 2026 17:20:12 -0800 (PST)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b8871718b00so470215766b.3
        for <io-uring@vger.kernel.org>; Fri, 30 Jan 2026 17:20:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXJnrxb14pasrqq5y/M8MwpnyWnr8kmDmRp/K0FyCvf80xpwnfEBUWJJ29ny/xjnOT3MRM+MxwoCg==@vger.kernel.org
X-Received: by 2002:a17:906:6a1f:b0:b87:701d:341a with SMTP id
 a640c23a62f3a-b8dff607a33mr279550266b.25.1769822411525; Fri, 30 Jan 2026
 17:20:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260130-getsockopt-v1-0-9154fcff6f95@debian.org> <20260130205227.6fb1d9ad@pumpkin>
In-Reply-To: <20260130205227.6fb1d9ad@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Jan 2026 17:19:55 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiiPxGrVxFzzf1nbx7_0abjZkhmd9oPximUxUyDM7gwug@mail.gmail.com>
X-Gm-Features: AZwV_QicYb2Y4IsMdcHkp6aaLn_xxvWlOuA7e1nJwap4TdBtycKshhvQFgQOM3M
Message-ID: <CAHk-=wiiPxGrVxFzzf1nbx7_0abjZkhmd9oPximUxUyDM7gwug@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 0/3] net: move .getsockopt away from __user buffers
To: David Laight <david.laight.linux@gmail.com>
Cc: Breno Leitao <leitao@debian.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Willem de Bruijn <willemb@google.com>, metze@samba.org, axboe@kernel.dk, 
	Stanislav Fomichev <sdf@fomichev.me>, io-uring@vger.kernel.org, bpf@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[linux-foundation.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12003-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[linux-foundation.org];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linux-foundation.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[torvalds@linux-foundation.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,linux-foundation.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DCAF2BFF1E
X-Rspamd-Action: no action

On Fri, 30 Jan 2026 at 14:40, David Laight <david.laight.linux@gmail.com> wrote:
>
> There is not much point making the 'optval' parameter more than
> a structure of a user and kernel address - one of which will be NULL.

That's exactly what we do *NOT* want. Because people will get it
wrong, and then we're back to the bad old days where trivial bugs
result in security issues.

Can you point to an actual case where setsockopt / getsockopt would be
performance-critical? Typically you do it once or twice.

              Linus

