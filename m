Return-Path: <io-uring+bounces-2236-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FE3990ADDB
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 14:22:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 263D51C232C7
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 12:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D3219580F;
	Mon, 17 Jun 2024 12:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dDlcVQdE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35C419306B
	for <io-uring@vger.kernel.org>; Mon, 17 Jun 2024 12:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718626964; cv=none; b=NpxKg6nwVXqiVaMZmwsbc4e9Ca02O3PpKvgwM9or9Ognb1wNy7NZvjNVFdjYIovsjsrt/zZEAOaTOuncDqOzoehhlYUjf3YIhxUXJTS22Miem39omMASfHKfq1si5E1dT1cS58mYpbsZJpvUIHlkiH+MorOX9UfbCfz0yZ8RPx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718626964; c=relaxed/simple;
	bh=dMfaMjRTJgJ/WDteiHFyX9xyfCPY2h+KRUqrKCbG2jY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vExn2gOgLfSVrd8vcvujxIsfWD1D4oQwSjA6N0s1Cx4nFFQ+t5VdRoD5tCuJzW7OTShWtCMjwukYE+2/lTCZFc1TH+JCKXUnVglZ1+e/7acRQLr0Q2Ie9GRFJzgH3A+TMwjuJhbkkTQ2xupHhEe1qSBoQGqcbMFO0pW9pa39xIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dDlcVQdE; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-57cb9efd8d1so1585382a12.0
        for <io-uring@vger.kernel.org>; Mon, 17 Jun 2024 05:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718626961; x=1719231761; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1UVxJDAA/IuWs4UCxc221wx0IQ9Rx7CdqJ7hPVtDTiI=;
        b=dDlcVQdE7Tj6aJQeZT0zF98e+0OshLu8o7UOJOuXgVfd0YdFt4hRP7yrX0nYq0l1Fu
         oSNvL/nVmpJD2rB3iMnPWB3M/UtyyeDmiwNS6kejrQWQXy6A4wnvNpInMWccR55f172M
         pwMXxbTwVM5xQqQ+DkBg9a4BaIYSr1k7NjIuz8H7Qw064Gjk7odd/ueI8dSpRM+eDvUW
         wvoxQgAm6fp1TvOcM52KYn3EXyT6SJ5NoLT1zHgXdpWP7dVuubEnvCBY2ClcHbbLN1m3
         hRYUfre9gG/wqx40hZ32uo79kgBMnLSK2n3J/T6pPnuIngqqp23evUqbRMV/IbRhKnmQ
         8hJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718626961; x=1719231761;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1UVxJDAA/IuWs4UCxc221wx0IQ9Rx7CdqJ7hPVtDTiI=;
        b=gfD0/G98F3L0d7K1nRyEqkNsOsfx1gT6TVCzEHf2ZS02wA2LuATC8xGv8hrx4LTJK+
         LhD72Vj4Fg+BlrGMzWHAlX1I5dzhmN1c+xEz+d+AEsVwSNXNf4r9mQ0h61rDBDPzuOcb
         AK1yxHM5hKapHfkIP/PtfJD0j0VALiafkPsvewfUNmL7y0WlVYSzxUjRjQKHyfBaKvxp
         4s3jEzI40PM1wG9kmVoOll4RnTyje2YS1BO6HEEXzsC4NUlsduo5F3mI4fUNkTxCoJfj
         /1hhX0hshUADqHrGuHSwQCLtLIWktIkIdd4P6owoAKTXSwTjNehPR/uREMTM5bQmUlN0
         i/5g==
X-Forwarded-Encrypted: i=1; AJvYcCV6QZTO9yC6LP6A/k6SeGLJA8EPIsVwvmAk+R8OI7kLqY45EMvhwws6ZBhmSuvOQqVnepMkmqIO3xQWXKOHdU+53MiUoCDre6g=
X-Gm-Message-State: AOJu0YwIM4QgLMoujO2ZArTmt0rlOaPBWszNJhRPTAwwuT8c4I7BLASH
	9JrwyWeQaaQiDRVgiWJ7pVClTlCT99ZGxxwPGnnOd/UzWFD9N9Tg
X-Google-Smtp-Source: AGHT+IG2/yQJphIejPI1mmKfM+x5vMfpMRi6lHQORA/YiGv4oXf9YDs5Wr3Fvg/i+quVKpjLBXJ6ig==
X-Received: by 2002:a17:906:c106:b0:a6f:4287:f196 with SMTP id a640c23a62f3a-a6f523eae84mr890366466b.2.1718626960733;
        Mon, 17 Jun 2024 05:22:40 -0700 (PDT)
Received: from [192.168.42.82] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56f416dfsm508412866b.164.2024.06.17.05.22.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 05:22:40 -0700 (PDT)
Message-ID: <6b4b27c4-1b71-49f9-bb85-8bad2a5a4170@gmail.com>
Date: Mon, 17 Jun 2024 13:22:43 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
To: Chenliang Li <cliang01.li@samsung.com>
Cc: anuj20.g@samsung.com, axboe@kernel.dk, gost.dev@samsung.com,
 io-uring@vger.kernel.org, joshi.k@samsung.com, kundan.kumar@samsung.com,
 peiwei.li@samsung.com
References: <bc9ae109-090c-4669-9be1-11ed6a6d39aa@gmail.com>
 <CGME20240617031611epcas5p26e5c5f65a182af069427b1609f01d1d0@epcas5p2.samsung.com>
 <20240617031605.2337-1-cliang01.li@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240617031605.2337-1-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/24 04:16, Chenliang Li wrote:
> Actually here it does account an entire folio. The j is just
> array index.

Hmm, indeed. Is iteration the only difference here?

>> It seems like you can just call io_buffer_account_pin()
>> instead.
>>
>> On that note, you shouldn't duplicate code in either case,
>> just treat the normal discontig pages case as folios of
>> shift=PAGE_SHIFT.
>>
>> Either just plain reuse or adjust io_buffer_account_pin()
>> instead of io_coalesced_buffer_account_pin().
>> io_coalesced_imu_alloc() should also go away.
>>
>> io_sqe_buffer_register() {
>> 	struct io_imu_folio_data data;
>>
>> 	if (!io_sqe_buffer_try_coalesce(pages, folio_data)) {
>> 		folio_data.shift = PAGE_SHIFT;
>> 		...
>> 	}
>> 	
>> 	io_buffer_account_pin(pages, &data);
>> 	imu->data = uaddr;
>> 	...
>> }
> 
> Will remove them.

-- 
Pavel Begunkov

