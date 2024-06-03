Return-Path: <io-uring+bounces-2076-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD1128D8242
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 14:31:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6354C1F263B4
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 12:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEC328062B;
	Mon,  3 Jun 2024 12:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="paHICZLC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="f3qWbxyI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WHXig8Ks";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AcmevNMq"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F8364F;
	Mon,  3 Jun 2024 12:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717417870; cv=none; b=HjDN3ALHs7s7uyenSMaGYqZjHj0FnH06ShJrJOyHb7hY2iUHjVLCRGLIbhn/pY4829EvOGdYoXAfV4ZGhg0zhuT4XRT7NsQRl9Ljz9Oi6hj1bo7MmTJrWuB7nt+T2QwWFSPChFytdq23Uot4xL5pihtNGEXT3B/RKLAe2WlGJfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717417870; c=relaxed/simple;
	bh=hOHeohRDUTCtFvpXo1EE1vFQ8GgEnhiXTAPgDM3uzXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N7NcAFdLcLu7QbhtPOa+MnOaqmZoqkvQO6f7aWsLraPu/PMdNPNO5UTiSeihEegSmkp4TfW6OU7hajs+BsLivvTvTXE8WNYRkwZ8/n/Y5QyPMVd+JkiztFdzwoxy6LLrBw7HkIjQb10tBOpHRRXDYpDVQGJ1PF/eD2KFVZTpjp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=paHICZLC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=f3qWbxyI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WHXig8Ks; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AcmevNMq; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6C15D2003F;
	Mon,  3 Jun 2024 12:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717417866; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O5KLPAXOU7O9Zmy/g/FuaV4GngJI7olAqvrZ4Kvt6hI=;
	b=paHICZLCGp80ONqknHFalzAt1kkCRlR0Z9QSlZS4VszonEOlvJ3549kiqbSPbi/sSKXb4z
	cIvqTWDSWb2+YFpYGCicZX7c8WhDo+fYxDHtiofhOfjyxWj+kv/rj+7rJekm3sBbVedKQe
	GqKVeKKc4GyC6Ca/ZZrc7Lg+P01viXs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717417866;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O5KLPAXOU7O9Zmy/g/FuaV4GngJI7olAqvrZ4Kvt6hI=;
	b=f3qWbxyI4YiJPerFsADqhlSLCuCoSY8XWlG2k6PmVp9TDTJfvqlv86qzZ+wwguEc0UK4CB
	87xNqQZoJmCVJODQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WHXig8Ks;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AcmevNMq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717417865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O5KLPAXOU7O9Zmy/g/FuaV4GngJI7olAqvrZ4Kvt6hI=;
	b=WHXig8KsBN2t3SUFevfVGyCz0n3zjib6BofjLAXbEnk6I9rI6rY0tt89NkEzGzcndOh6nB
	UIvvKPubgrTlcdXvJ+wG4Za5mTVoOg3crxM+lrDIK1+QBFEsH97TaFYt1ffeBMABV7MQVC
	IndNek6ci1hwNLbIPlnx60PaK1ItRSc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717417865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O5KLPAXOU7O9Zmy/g/FuaV4GngJI7olAqvrZ4Kvt6hI=;
	b=AcmevNMqwwEvq6QfSVtCAq/epBZVDnBBs4orcsVinsWji4hpwhqC922nY+0+DXu+wAcwvZ
	4hSsbwob3Wki4FCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 27F5313A93;
	Mon,  3 Jun 2024 12:31:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 28xHCYm3XWb7PAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 03 Jun 2024 12:31:05 +0000
Message-ID: <ee20a47d-3131-41c2-a2fc-39017f535527@suse.de>
Date: Mon, 3 Jun 2024 14:31:04 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/9] block: Add core atomic write support
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
 martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk,
 brauner@kernel.org, dchinner@redhat.com, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
 ojaswin@linux.ibm.com, linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org, nilay@linux.ibm.com, ritesh.list@gmail.com,
 willy@infradead.org, Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20240602140912.970947-1-john.g.garry@oracle.com>
 <20240602140912.970947-5-john.g.garry@oracle.com>
 <749f9615-2fd2-49a3-9c9e-c725cb027ad3@suse.de>
 <a84ad9de-a274-4bdf-837a-03c38a32288a@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <a84ad9de-a274-4bdf-837a-03c38a32288a@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.00
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6C15D2003F
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[27];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,mit.edu,google.com,linux.ibm.com,kvack.org,gmail.com,infradead.org,oracle.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	R_RATELIMIT(0.00)[to_ip_from(RL7q43nzpr7is614unuocxbefr)];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]

On 6/3/24 13:38, John Garry wrote:
> On 03/06/2024 10:26, Hannes Reinecke wrote:
>>>
>>> +static bool rq_straddles_atomic_write_boundary(struct request *rq,
>>> +                    unsigned int front_adjust,
>>> +                    unsigned int back_adjust)
>>> +{
>>> +    unsigned int boundary = queue_atomic_write_boundary_bytes(rq->q);
>>> +    u64 mask, start_rq_pos, end_rq_pos;
>>> +
>>> +    if (!boundary)
>>> +        return false;
>>> +
>>> +    start_rq_pos = blk_rq_pos(rq) << SECTOR_SHIFT;
>>> +    end_rq_pos = start_rq_pos + blk_rq_bytes(rq) - 1;
>>> +
>>> +    start_rq_pos -= front_adjust;
>>> +    end_rq_pos += back_adjust;
>>> +
>>> +    mask = ~(boundary - 1);
>>> +
>>> +    /* Top bits are different, so crossed a boundary */
>>> +    if ((start_rq_pos & mask) != (end_rq_pos & mask))
>>> +        return true;
>>> +
>>> +    return false;
>>> +}
>>
>> But isn't that precisely what 'chunk_sectors' is doing?
>> IE ensuring that requests never cross that boundary?
>>
> 
>> Q1: Shouldn't we rather use/modify/adapt chunk_sectors for this thing?
> 
> So you are saying that we can re-use blk_chunk_sectors_left() to 
> determine whether merging a bio/req would cross the boundary, right?
> 
> It seems ok in principle - we would just need to ensure that it is 
> watertight.
> 

We currently use chunk_sectors for quite some different things, most 
notably zones boundaries, NIOIB, raid stripes etc.
So I don't have an issue adding another use-case for it.

>> Q2: If we don't, shouldn't we align the atomic write boundary to the 
>> chunk_sectors setting to ensure both match up?
> 
> Yeah, right. But we can only handle what HW tells.
> 
> The atomic write boundary is only relevant to NVMe. NVMe NOIOB - which 
> we use to set chunk_sectors - is an IO optimization hint, AFAIK. However 
> the atomic write boundary is a hard limit. So if NOIOB is not aligned 
> with the atomic write boundary - which seems unlikely - then the atomic 
> write boundary takes priority.
> 
Which is what I said; we need to check. And I would treat a NOIOB value 
not aligned to the atomic write boundary as an error.

But the real issue here is that the atomic write boundary only matters
for requests, and not for the entire queue.
So using chunk_sectors is out of question as this would affect all 
requests, and my comment was actually wrong.
I'll retract it.

Cheers,

Hannes


