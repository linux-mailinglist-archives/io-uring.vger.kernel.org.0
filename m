Return-Path: <io-uring+bounces-1529-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B38138A3188
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 16:52:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 695BC282F86
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 14:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02173143C42;
	Fri, 12 Apr 2024 14:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ABEjoOUi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C13714388E
	for <io-uring@vger.kernel.org>; Fri, 12 Apr 2024 14:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712933525; cv=none; b=YfLo9PMFzcesuVOwTx4Zco0+Fb4Suvkf3Mlw8LiaCz0BgM1GF0NrMh8togs/JmsUHWLkJrL6nvwYYY1jeeCzwyRGIj3Dc0akFcwko56Sj735vcjnUN1lcMiWeeOYR5O/HLOknAo+xGO6DNsE8g/gn8DzECDFuDffj3cqt7RqLxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712933525; c=relaxed/simple;
	bh=tC4whiuUBgU0tgUJ07orp7mDp8lk79L9JcinxNXeTkY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bPRNKksCjq/soiky2ogeVtv52O/hGBP96IiCJl/fEgaeMp+PmKccZXW2L+vvICT8UIoJf8LllpQxGc0GeGl70q7ukjXT1LHiO8WkFrlvn9GJ+Z4KV1oUrlMleaWhorgBJXg2zRHdtohPtx1noOMCjTnphHIuKdsDHTSqCm6oCT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ABEjoOUi; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-36a29832cbdso1444675ab.1
        for <io-uring@vger.kernel.org>; Fri, 12 Apr 2024 07:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712933522; x=1713538322; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s9qBhQRjLa3OV5PgQj8QLd5DVc7ylCIA4CAy8SLusss=;
        b=ABEjoOUiUIFFDmDL+A9G5GvI1+yER9Mp3Ne9M+902+JAR9hHZbxcVADxsVGEkx1cAx
         +UaxnBH1Pesr7AA1gTGoYmo1+K2jn7Ni2uhXJFnu2P9z/tdx5r7jcfYI9hSfNAEVyc83
         3sKoWNGyE6CPTHc5S+CcisQJcvGosrGKMHPlBg/FcOcYtrWZwNMyQvbT71gN9ZvQzphY
         NE7T4yu0L92TOcqE67sEEM33tWWl7Fhr+k9Sw+z5Q1J9OdFHUSjk+9CAJ1q7Y3IGf2/Z
         mofPIhFRCZGPE2BHAeeeBTWoCDnn5+mI2u/KUDR9x3x6RSsm+0qqPraFMsOOCOl0CDnE
         yjoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712933522; x=1713538322;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s9qBhQRjLa3OV5PgQj8QLd5DVc7ylCIA4CAy8SLusss=;
        b=lJSwNgewxXRYCWl7XqaYSqQaje7x2BC9GgkFfmF3fbpcQ9bCUt3vx76E2FaOObG+yD
         juZUnb79LotKKcd3GJA3Z6L6Jl4gYqIIC/Or6Zd4Vl+9OhVzbtn1b3Fu7KhjdK5wkss1
         /oQpwQVrdQqr5NGJdU6s+YJHPmsmUX3BS1eR2Rgkc2J/kxf78cNx5b45qbrIANukICrF
         vYZ3ueNjQJzotVngXt7Q61K1BTnX7/V8EEij+rXX7KPbXPjbVj/GFLHkqqRn/Fu/yIlI
         GjV/DGvUbnMznF3Y9tyONEi1PB6z3ENcQpNyVyHcClruyiyjeCKjsX0Qk6CWH1Eem/Nd
         4Ufw==
X-Forwarded-Encrypted: i=1; AJvYcCVNYGvKOu01NMBiNQ8E50/h6EzG2SR3WwILeT+C0Llh7UtJMPPawdn0Mh+VUZ3JKdUFeWP7uY7dLWqauJS7KtJNsQh3mrkalps=
X-Gm-Message-State: AOJu0YzERd7Q+P/y5KcPbgnFFmMESBgDhd3XfBxYRUzWdwhSKT+FB4q0
	QCcYJaUk/9Uuvb8zLR+TyNKP2xDY7jK3s4Bra2nycjXb4s73Pv691W+89Ns7nQrC4KIM+e6xZ+A
	Y
X-Google-Smtp-Source: AGHT+IHv7DmKcH3TmaX4OpLVohoHfoWGiH79kmDJuc8CsQfWLlOU2k3e6Ksflt+dUU4ChOMbmYIEZw==
X-Received: by 2002:a92:db46:0:b0:368:974b:f7c7 with SMTP id w6-20020a92db46000000b00368974bf7c7mr2927250ilq.0.1712933522433;
        Fri, 12 Apr 2024 07:52:02 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p11-20020a92d28b000000b0036a20dbcb17sm1029237ilp.16.2024.04.12.07.52.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Apr 2024 07:52:01 -0700 (PDT)
Message-ID: <9b172e19-1292-480f-a72f-6860c2084430@kernel.dk>
Date: Fri, 12 Apr 2024 08:52:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/6] implement io_uring notification (ubuf_info) stacking
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski
 <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
 Eric Dumazet <edumazet@google.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1712923998.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Reviewed the patch set, and I think this is nice and clean and the right
fix. For the series:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

If the net people agree, we'll have to coordinate staging of the first
two patches.

-- 
Jens Axboe



