Return-Path: <io-uring+bounces-8563-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00573AF0BE3
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 08:44:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A19593A94C9
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 06:43:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967C322257B;
	Wed,  2 Jul 2025 06:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="XJChU8ck"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968481EC006;
	Wed,  2 Jul 2025 06:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751438659; cv=none; b=GBg40UhbGYcloublkSxZ5oPlzyPkIgsNd/FkQLM0ntjCLqy+XoKBlBc/SbyY2riwwzD70Y8OgOmUUO75m3qRfOCsjJb0xMtefZaDXVIrHa0rX9gDdH8+Y1tjaPw+lHRGN0pWyJwa05Kmb9wOl83VaKb1xbrhX0GmkGqgO3RKoOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751438659; c=relaxed/simple;
	bh=LXET+yFHDbgo4qVwdOx2McXfbA8uUlH7HtuZp6PV4+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TaFPq1RK/rS4f5JVX6aBVl5CIEtSHv0hucRX9aGrlyxj0m7ALVDQRH7ufQqh0cASGmTKCr3cl4zWy2GD6TJ7KpHbKSxzSvosVnjgY7630upslyW/9kRgxcigpFVeTwa5DZvRrsQhpviJt9jrQAQiqYC6+MavcrKrDYmVc/gKBrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=XJChU8ck; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1751438649;
	bh=LXET+yFHDbgo4qVwdOx2McXfbA8uUlH7HtuZp6PV4+g=;
	h=Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=XJChU8ckSBAkU66lOTuIgtlFyCgF1v6oKuJ4iKVHQy4QHacbvCpthFs3GYAqKGy/y
	 Cl4NAYbtkmiZ4hiJQTnhwAeftTHPQP9P0Xnb+YPEc2x/aJm+j8ENjf1R51C8zDhJ4t
	 jOvbzkGT/0FWo/KCKPsFBCgais1DiKoyaYRKoyTsHyfAObuSlkUOKi1JWK869VWgwj
	 TpCyUzJoMlBsGUGawMruOoVo7NUN4OcSg/jP1kZSvHRCfxXl0sqqHFIOhkEkMoQi57
	 ScmTS5T5iFKG3MxBGsgDfJvsqZGHm7Z70pj8z6UvVg2YjlPoGT2KJIIHQwYn6GwIwz
	 TOSIS4lXANtzA==
Received: from [10.0.0.2] (unknown [182.253.126.240])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 076D921099DE;
	Wed,  2 Jul 2025 06:44:06 +0000 (UTC)
Message-ID: <33d93770-886f-4337-a922-579e102c0067@gnuweeb.org>
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Wed, 2 Jul 2025 13:44:04 +0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring/cmd: introduce IORING_URING_CMD_REISSUE flag
To: Daniel Vacek <neelx@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>,
 Caleb Sander Mateos <csander@purestorage.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Mark Harmstone <maharmstone@fb.com>,
 Linux Btrfs Mailing List <linux-btrfs@vger.kernel.org>,
 io-uring Mailing List <io-uring@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20250619192748.3602122-1-csander@purestorage.com>
 <20250619192748.3602122-3-csander@purestorage.com>
 <76d3c110-821a-471a-ae95-3a4ab1bf3324@kernel.dk>
 <CAPjX3FfzsHWK=tRwDr4ZSOONq=RftF8THh5SWdT80N6EwesBVA@mail.gmail.com>
Content-Language: en-US
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Autocrypt: addr=ammarfaizi2@gnuweeb.org; keydata=
 xsBNBGECqsMBCADy9cU6jMSaJECZXmbOE1Sox1zeJXEy51BRQNOEKbsR0dnRNUCl2tUR1rxd
 M+8V9TQUInBxERJcOdbUKibS8PQRy1g8LKJO/yrrMN8SFqnxYyX8M3WDz1PWuJ7DZE4gECtj
 RPuYN978y9w7Hi6micjraQeXbNp1S7MxEk5AxtlokO6u6Mrdm1WRNDytagkY61PP+5lJwiQS
 XOqiSLyT/ydEbG/hdBiOTOEN4J8MxE+p2xwhHjSTvU4ehq1b6b6N62pIA0r6NMRtdqp0c+Qv
 3SVkTV8TVHcck60ZKaNtKQTsCObqUHKRurU1qmF6i2Zs+nfL/e+EtT0NVOVEipRZrkGXABEB
 AAHNJUFtbWFyIEZhaXppIDxhbW1hcmZhaXppMkBnbnV3ZWViLm9yZz7CwI4EEwEKADgCGwMF
 CwkIBwIGFQoJCAsCBBYCAwECHgECF4AWIQTok3JtyOTA3juiAQc2T7o0/xcKSwUCZ/1d1QAK
 CRA2T7o0/xcKS6fgCADlWw9ZPvM8Qv9Zdhle6zyCnwTnoZsadBnabY3NGFAo0YVNnByUy5HN
 inN92F1W71D06IrPJr/0rcCt1mJWM8TuQiU3LdEC+1Go99XA48x94grtxkZiBKKUmGU7HU4p
 5bdTj3Ki8HYCaaHz73VeLsPGvXc6uzMtHCHubErIvbf1VsXOuGo4xhxveT/RutKrJto81YWp
 zlrvbU8DJOvRuzBbNk/N/SgpyceVT+g3hAnoySUV1nweeNdnOZZ8LsH5bjCyJ8oq0n1NfngY
 u1BXSqCNKPh/QrVsXpvlWuvWog1k/GbtxQoIJ2lizJPrxA8kjUI/oQ/S9DDejiLD7yzXeUUw
 zjgEZ/1bwhIKKwYBBAGXVQEFAQEHQELDQDfZ2b77GoJFe9RHDa2xOd3X4QZPuRcqvwu2h74j
 AwEIB8LAfAQYAQoAJhYhBOiTcm3I5MDeO6IBBzZPujT/FwpLBQJn/VvCAhsMBQkI3sMOAAoJ
 EDZPujT/FwpLC9UH/Am+C8AQsDFNpTUWzkqEwTMAcXBES9sRr9Hx3AbysOuEF28LwAGaHlx9
 pn17tiusZcDQ3TnJnbp4pdUt6n1HYZqR04Nrkz7fbirFJQ214vHFov0lc8g26OdEVHWqHtKN
 GGAryZaaT2c8aqRX3X8BraFyjj35cFLKeUJDnKBWDt4ztvQnnHPi9GH74h1O/mglcMyM3EnM
 AOWKeYsHlJf98mt8gRamko7WOG473faeN1IO/iTZIdUEjzsTmzITehrqMm6FVFPFOUtmQG4M
 9X95XOk5hOL7VvJZpLc3lZdccyaWP2yJ14AX3QMBJjZuPpfDCJCVPb7PBa8fOWMghEO8hTo=
In-Reply-To: <CAPjX3FfzsHWK=tRwDr4ZSOONq=RftF8THh5SWdT80N6EwesBVA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/2/25 1:27 PM, Daniel Vacek wrote:
> On Tue, 1 Jul 2025 at 21:04, Jens Axboe <axboe@kernel.dk> wrote:
>> Probably fold that under the next statement?
>>
>>          if (ret == -EAGAIN || ret == -EIOCBQUEUED) {
>>                  if (ret == -EAGAIN) {
>>                          ioucmd->flags |= IORING_URING_CMD_REISSUE;
>>                  return ret;
>>          }
>>
>> ?
> 
> I'd argue the original looks simpler, cleaner.

I propose doing it this way:

	if (ret == -EAGAIN) {
		ioucmd->flags |= IORING_URING_CMD_REISSUE;
		return ret;
	}

	if (ret == -EIOCBQUEUED)
		return ret;

It's simpler because the -EAGAIN is only checked once :)

-- 
Ammar Faizi

