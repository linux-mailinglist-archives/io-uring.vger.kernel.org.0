Return-Path: <io-uring+bounces-8721-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61CC0B0AA7B
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 20:59:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B9BF3B7690
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 18:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0738C2E6D31;
	Fri, 18 Jul 2025 18:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lSeHo2Ak"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FCB18E20
	for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 18:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752865181; cv=none; b=br/vrsOIX/epYH4gLCpL2lxoEIHrxPfdV3nWlno/nglxj8SsbYln50l+Ji1OmDjyCRF0o85WwQAK6I04zR4GRCeUzaHu+iP7N06RHksjLaitLb6vQ/ub9K/SGAAYRyMhOEOePHUYc1oRJNpBz4DH2wCGUxgU+2Vh8K4MbNaS1v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752865181; c=relaxed/simple;
	bh=G4f51BRTi6C/W+L9gnTqwbijvqcZYtbg9C94Byett0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pirFPFM2RN/gBXwxfXxEkbxRYxCaYAMmudJjqTpB0nnyjrWNBvdRmQuDDF/nieaWCHe/UbJjdWJ3f3Zk2dAPWkWOJCnKHEsUBl76zWiDhMEBcfaO5AgOve3+Hn+CyPc5gSmicTLDZGf6OGGB3BtclUCPwFYIj2rbZoRNlCZAwvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lSeHo2Ak; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-608acb0a27fso4130094a12.0
        for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 11:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752865178; x=1753469978; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UBuAawgb76/Pc+oDVY6dTFunyywqW00LDyDItgXMHws=;
        b=lSeHo2AkOs73+c3Q2vOcGmAy6fBCmBG13PaiZWFzeE9YTmSh3vvh//wU9eCrwJfx67
         HJTreLZLbGjO4KOJIcCZBcqHPUzNI1dheBFw0/7SNjzQKYrrleGoxNKyenxygrOjxJsC
         QC2vfkQ/q7dyHk4UcjtkcAy+kbZdF6thgNqsWfzIAgKPWcjbgeeuS6geogXoW8NWOKwG
         fco0NBgs5WiDzegtfl2g79KijPfwqncMgWSuvBQgsmH0FG4ETYDnRy7AucxNaqX81pm2
         eg4xUd3mUP76Txp/8T71BRdjoPPLNgrN0LtNhQEI/k2x7HdYqEEfgnqI1aQxM4xfydLe
         87KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752865178; x=1753469978;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UBuAawgb76/Pc+oDVY6dTFunyywqW00LDyDItgXMHws=;
        b=M8bCiKuyPpcaq6sZvMsJR8HkTNqVXFMflu3anukcvB69FHV0mXbZHWwvvajXJcypim
         Qoe0rY9Duha4ekIKdzfAH2J0qVjooZ+QD1eSqREZBeLr1Xo5LVoTVw/XJ1k7F4mO5fKk
         ciXC0yWXXo9qFd7lDr+vyqiAQ/1VsHlhnf31ycAe0VJNprtshE1qckxUeLaUZzNP7qQJ
         94cmbj6tYeFBaLNB+EljL5wmu96rwNhXBAMQgDX7HxiK1FO6D45QSo7k9kermHSRlOBn
         RZiIrijZPk1vK/JPA86fNbbzW8XH7DggJDC2VM/qqYYeJzSrkd1RO/cjeP7CwqqJdXAG
         w7wQ==
X-Gm-Message-State: AOJu0Yzqxr1sv/Pp/dcCFROH2mYZRN4scXTwJ4gcgVHOS27VHaP+EQwV
	1fQt5ERVAaUpWcKECg95guZwIVcT8PN3H2AEG5bkVQHTH0qnstR15/jtXpD9rQ==
X-Gm-Gg: ASbGncup7u9IKr+pJuQnu5f0ljueOpfcqT9Z62qVbX83/IcbztVjR+DWdyo8ifBHGG8
	iqp6Nc2xHLaamZmB+McyA7JN0gpqdukT3KVzKpVX0pxE3kDbWjUxIUDaNYaygVz1hb28x2IShbb
	0f+3HdTAkvLSAjQ7ZQ7tBPBtBRTYJvvw+iKQLnK1FmwJQEdYkjAeoQr87KRQLarBKC+XVtLnylJ
	bN5+8VHDSfnKwU4FYjOyHJoX/jJNx+38xVaON8h5Eret3AJRFMkpV/mhGFE4DfzERV3gD2XZMXI
	VQ0UTw7rB1TVM8KXyOawvsidbBDHYWvx/zHovytb3RV/TbDSRdeefzEaAnZVrxJVc9JytRyWZiQ
	UQJyTiKLwkHanOFy7IfN2n9/Is456x9wueVsW7FFvvy4=
X-Google-Smtp-Source: AGHT+IECElRbwyUuozjAVSUH4iNsTmIhd3CZRdbiCVkCCS3tAlJHKnumda75PiOlF95vypZj+9G7iQ==
X-Received: by 2002:a17:907:3e1c:b0:ade:3bec:ea30 with SMTP id a640c23a62f3a-ae9cdda3627mr1166944966b.1.1752865177845;
        Fri, 18 Jul 2025 11:59:37 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.141.246])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aec6ca7bc99sm166247366b.109.2025.07.18.11.59.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 11:59:37 -0700 (PDT)
Message-ID: <ed4fcb1c-795c-4af2-bb47-7c6bd5c438cf@gmail.com>
Date: Fri, 18 Jul 2025 20:01:06 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] account zcrx area pinned memory
To: io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <cover.1752865051.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1752865051.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/25 19:59, Pavel Begunkov wrote:
> Honour RLIMIT_MEMLOCK while pinning zcrx areas.

It appeared cleaner resending the whole thing. Let me know
if a fixup patch is preferable.

-- 
Pavel Begunkov


