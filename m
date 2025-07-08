Return-Path: <io-uring+bounces-8624-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B41CAFD647
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 20:17:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFDBF3B3B45
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 18:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 419FE21B192;
	Tue,  8 Jul 2025 18:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Fe8WUe+5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B277F2185B1
	for <io-uring@vger.kernel.org>; Tue,  8 Jul 2025 18:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751998670; cv=none; b=ABfJLX8WXtWMzUY37g2Czjp75iYobiPocaK05tarZ7POAy8U2h3z+3bURUN69AA0h9dJAlmb/iV/gefxTMXbsWjtcD1E70rtSAM2zXIQWJJSLa6kEISOH8rgE9rqAlEPQTSr5SFEUQVcdhi2WdmcIz8dGAdcfQgN51oEhuAHYSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751998670; c=relaxed/simple;
	bh=LpOkjb+ecQQBtOWkcVVUBt5c7MvC87zMsmyehH6sHDk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Klf3VONun20tsQO4Z8xhHOILm89QAIfLz/sbZpiHdZodBqoyenkZ2SCmXtMtIXMt4QAlXM9um5u8G2JmpTKwpj2LjIdfL4iF7IJtmhjujUk+84rowABCri17cwL37TUYLqZqsYlOyfqwhZFTuV7Si0znboPyW+w+nVhV22JDAnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Fe8WUe+5; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-86cf9f46b06so168930839f.2
        for <io-uring@vger.kernel.org>; Tue, 08 Jul 2025 11:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751998666; x=1752603466; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g7oks48muiKNQ9MQb0raKT3/XZo9cmEOj4qy77c9F8s=;
        b=Fe8WUe+5bI4LSraBHXz64gIq1Y6YQHak3Lbyk0xWGgqJewgRMwjkaAFEoiudlRA036
         eU7NMXRp2CCjCbB8HyiO1lMkXlDVFmvWXvkrvWpV3AZ1G0IGbuxNHLLWzZw+PKm/s43Y
         17sgU8aZaN7F3KELr4F3xlyHL4d8E6iH2JBjfSZxb6E7OJz9znHtOgGFeNJb3ygeKKTX
         zC7xaSSLSJcAmia3kkXONlJyPRTgdGQckLcG6JErKKETaG3Nj7QP7Td5l+4wlwMUZSRh
         59S+phlVk+5YfPwbqVrhbkEkfrzI/Q2SM+x16x0rZZzfwo7TRk7xA5lFjdIv0zoFRKG9
         unEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751998666; x=1752603466;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g7oks48muiKNQ9MQb0raKT3/XZo9cmEOj4qy77c9F8s=;
        b=rm6tCctXYKUottukiPsvv7UHOZHy1dfp6OkwhXx+P+9pT1R5WMupdzpAc9yBTc80s+
         wWQTYWo26OWUbkbClaAbm4RkUPQpFZyv5OAcETOLIabCmri1gowX/VLevAgHayIvZvRj
         VYN8xKEyvusqJMIsTjGClNukEmSpAslCi2tu4jLOSaJPt5Bil7TvaLoWftZRNrNUVUdr
         TvZTPgDaE2M+3D4hSJVi4Tokzx6YM+GE5ppa+PR3ci+9xqmGErzNvU9OPiY4vOeM10ol
         uWfWYT0Ol3L/lXA3TpYHgW+4JUxilyUz6Fn9Eax1AOPl6pe9HtQ5xiA6RXuhcuMAUSB1
         ixtQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnaEtmrwFkXLP13lq1tfVednjxM4+17wpUvl61xsLsrifgXUrQrUCWQVlEa9vdGpa00glqUjaKXw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwpOptWq79mpTodqYRrhlL4JpTqBeXEiMODDfq1Yk0OdBzQkvaH
	1RrjSBzp/oMGCPHSFvIHxkmnKY3CDI976eqTunBpgUQtUP3TYWLAb7cNfbd1+k3kkXg=
X-Gm-Gg: ASbGnctnW0YsMb06zy73VTgtJhT2nZ4SQtbQIpWLkp9k8pshSLiZoS0r7sUQupZrcaJ
	pk3ClpKxE4rbJeZRTKV4y9lAsS/3UqZCB/w3ZpHkiW8MZdoS2M/q38pbDpd8iZB6RPfKT0fBlCk
	wL8KoQRFQuoIcSMdSfQWCypDkep/1iX/g6JZwARVHq/eE84x5P+5TjV1xKIW/xnpC8vmbyDB3mL
	+k6EAabQp4b9LMuNd5MmIpbaW2UzFi/Ulw9ib1cAiEMvaIkw7lFb9RIWMyFXdFq39PBnEV11Kqi
	Htc+/nGXUMbCLuK61lJd6m3K2y8aQJP9tKsKVmGmWLY6a23oIKH1H4L7mQ==
X-Google-Smtp-Source: AGHT+IGQnxN9Juqo5ZTXTrtTXAYwJOZx2V2bAQvz67ZgmfrWs8KU5VcAU1pY9C/YikiytA7oWFC7vw==
X-Received: by 2002:a05:6602:2cd1:b0:875:dcde:77a9 with SMTP id ca18e2360f4ac-876e1667944mr1871390039f.14.1751998665602;
        Tue, 08 Jul 2025 11:17:45 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-876e07bc6bcsm297705939f.13.2025.07.08.11.17.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 11:17:44 -0700 (PDT)
Message-ID: <76ea020f-7f57-42d5-9f86-b21f732be603@kernel.dk>
Date: Tue, 8 Jul 2025 12:17:43 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] btrfs/ioctl: store btrfs_uring_encoded_data in
 io_btrfs_cmd
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
 David Sterba <dsterba@suse.com>, Mark Harmstone <maharmstone@fb.com>,
 linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250619192748.3602122-1-csander@purestorage.com>
 <20250619192748.3602122-4-csander@purestorage.com>
 <c83a2cb6-3486-4977-9e1e-abda015a4dad@kernel.dk>
 <CADUfDZr6A51QxVWw2hJF6_FZW7QYoUHwH-JtNEgmkAefMiUjqQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZr6A51QxVWw2hJF6_FZW7QYoUHwH-JtNEgmkAefMiUjqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/2/25 1:51 PM, Caleb Sander Mateos wrote:
> On Tue, Jul 1, 2025 at 3:06?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>>> @@ -4811,11 +4813,15 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
>>>       loff_t pos;
>>>       struct kiocb kiocb;
>>>       struct extent_state *cached_state = NULL;
>>>       u64 start, lockend;
>>>       void __user *sqe_addr;
>>> -     struct btrfs_uring_encoded_data *data = io_uring_cmd_get_async_data(cmd)->op_data;
>>> +     struct io_btrfs_cmd *bc = io_uring_cmd_to_pdu(cmd, struct io_btrfs_cmd);
>>> +     struct btrfs_uring_encoded_data *data = NULL;
>>> +
>>> +     if (cmd->flags & IORING_URING_CMD_REISSUE)
>>> +             data = bc->data;
>>
>> Can this be a btrfs io_btrfs_cmd specific flag? Doesn't seem like it
>> would need to be io_uring wide.
> 
> Maybe. But where are you thinking it would be stored? I don't think
> io_uring_cmd's pdu field would work because it's not initialized
> before the first call to ->uring_cmd(). That's the whole reason I
> needed to add a flag to tell whether this was the first call to
> ->uring_cmd() or a subsequent one.
> I also put the flag in the uring_cmd layer because that's where
> op_data was defined. Even though btrfs is the only current user of
> op_data, it seems like it was intended as a generic mechanism that
> other ->uring_cmd() implementations might want to use. It seems like
> the same argument would apply to this flag.
> Thoughts?

It's probably fine as-is, it was just some quick reading of it.

I'd like to stage this up so we can get it done for 6.17. Can you
respind with the other minor comments addressed? And then we can attempt
to work this out with the btrfs side.

-- 
Jens Axboe

