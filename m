Return-Path: <io-uring+bounces-12078-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EPzfCR0EhmmyJAQAu9opvQ
	(envelope-from <io-uring+bounces-12078-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 16:09:17 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BC7F1FF7B5
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 16:09:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4D582304812C
	for <lists+io-uring@lfdr.de>; Fri,  6 Feb 2026 15:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 895AD27F18F;
	Fri,  6 Feb 2026 15:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eCd7NkE+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E80027E07E
	for <io-uring@vger.kernel.org>; Fri,  6 Feb 2026 15:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770390507; cv=none; b=T5sLcEHePSxw4ARTWylBZhj/+2K0nQVVh7NZAiji4RC/bvAKCbYCsGhCRoavdfThLou0Dcvxb3RezjaASAr3aDfZlJ2vFFVO9o0s2QK8gl6eaAY1FUI5sPciTpT7L7aw/bPnwjiUnS8sdsatSo8FmsVnrRu/0t3gj1Wx4DfTvpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770390507; c=relaxed/simple;
	bh=iXZMdJH9KCj45jiaEgTtZgCDvU8SDQ8wk/c43hOnQRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ldzD2a0sE8o2IfcR6DR4l6k5kpZW5TgjOD3LOqOVYNUdLhPA1kNsus9HhEEqXFmc0KKzZ9A75zniGoy/7R7gn8tpf9fmZmVFQZwZmS1x81aCNuUqbbNi3hNWwJEpZL70YvwrnypN35VRKOBK2O5FRItWzo0CSgb+DJVn7AFuhWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eCd7NkE+; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b872f1c31f1so268041766b.0
        for <io-uring@vger.kernel.org>; Fri, 06 Feb 2026 07:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770390506; x=1770995306; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+//MQb8s0l4sWUa5GTTqN5W/h3z8UEKAbzUgv3O53tU=;
        b=eCd7NkE+OVD2yYkCBhMxzoRQWY1T3D0nnEviLAKbo06Mc0BzUgpeJ4TGyxGC+E4ila
         YohFwbNHCZMr+5eOerrzoKu8eOQ9LYGS0trecKV4amXcYesyZ1aXInc+C2i3Wv6vdVL6
         HXxJ3aaTxlNpvJ4Otm6joAActpfvn8epQiG6aowUpMNWvCtxBtTb5+rr84YsaA1Iea1l
         2TFhI9af0iZXEzH7WO3e30rXZiqdaoQRvFnWWsQ/TyL0w6PtgoYa9/agoqrsAPjnK9K5
         BsuDWCVixlh9Az6mpXvET4+NQTJPe3F6qlJKmZwQ3252ns6ivce148s5r8eQS3ru+eGb
         q1iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770390506; x=1770995306;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+//MQb8s0l4sWUa5GTTqN5W/h3z8UEKAbzUgv3O53tU=;
        b=adDsD/DsC4/xwdx+WeXnyQeY4uP5orGT0lLO+tS3f7f+wzVAmBbXv9xXttKgVTjnTU
         TiC3vXvQfgkA1b8XEBO0V2RawvLA/NtdCqrzCV/xnLSM1KuJEoS5qBlTPGBQhHVdttpb
         o8kzLfseDH1EFLyyc17lbn5KPuFg+EcU8kAXCYmEwhp3aM2os0moLvu19WZdo/MURawe
         P8d6kxViWyVi+WD+69gB1nDHKnjvgrOUHMmJp2Lv+9S2H2F1eLTug0KRVqrp/1TwAJ4P
         +0zXvP5buwcT1tjMDqAgigXYIVxsmtVSEhd8uPb0SGbu1WBruoj3z9SsnK5noXj2W13W
         n2WQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmTcbfAcwpq+T99Xv/Nvkp/MLSoJYqEbMcBvLQzv9Gpzu+9FqLTG4cCBgzk5bdOhyZrqjfMXg7CA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1XeDFIoCgp9zT/23TU5jbtGRRsdFDQiOn8Lu8ELLtNgmpZAaD
	CtOU1b69Bf6NjNjOVHaAy23dwQrRBxmwj1nYeqelSJBHONmkO4wwJkRb
X-Gm-Gg: AZuq6aKk7KXoG1EPkc26qNc1Uekvz3ZyfBHm88C5ebqwfpfiioN5chtMeWZ15vNw3bs
	6W5EOMgMw9gpOVOQoz/G05pe1sMZhDpwuEA5xBxMGsiPNg7Q/dluXJj4RkqMyBpMfXYBm4JTewm
	NnXQE07o0YLNGftnpM9PM+b/fkd5Svu2+P7WIlBZl0IOzKL/cmrl5wikZcQUQr3Wr+DAhLY5LFY
	nQiDarGwfDIXWYl7Uuegllvu/OhyxRzHpPT6hCYI/gvQCRD5OkwTyhpAhNhLt+nG9xtHJuw/3JE
	Wu0QUXyV+Ii2ozuoHJ5qFQl2Zxfc25VFBmbRpctTvu4w5lfhEstT5pP/go69bGJm1YOPxsY3JB7
	KqmPgoVACJ6h7Gc6Z8q8KHwkw5rlVuk0y1+ceTcA3qCc+PuHB3rXleZYATYqSM+tYaI3uB1DSIT
	rMxmG+u4Sa8/69RP82vcxO7qJlNrpbP5+uzDtd+icf1YFpC7fQoyjlp8nsGfM3vXqOxzczTjJTA
	nrIJVJNBbOtIJrsltxGG52vAypV+rBm9PG5YXPgUuCegHcfYlEtXIfIgg==
X-Received: by 2002:a17:907:9413:b0:b7a:2ba7:197e with SMTP id a640c23a62f3a-b8edf25c528mr163107566b.29.1770390505211;
        Fri, 06 Feb 2026 07:08:25 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:4691])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8edacf1488sm84857466b.51.2026.02.06.07.08.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Feb 2026 07:08:24 -0800 (PST)
Message-ID: <3281a845-a1b8-468c-a528-b9f6003cddea@gmail.com>
Date: Fri, 6 Feb 2026 15:08:25 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "Gohad, Tushar" <tushar.gohad@intel.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Nitesh Shetty <nj.shetty@samsung.com>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
 <20260205174135.GA444713@nvidia.com>
 <dbcc2912-e1df-491d-b1e0-7812279297de@gmail.com>
 <20260205235647.GA4177530@nvidia.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260205235647.GA4177530@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12078-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BC7F1FF7B5
X-Rspamd-Action: no action

On 2/5/26 23:56, Jason Gunthorpe wrote:
> On Thu, Feb 05, 2026 at 07:06:03PM +0000, Pavel Begunkov wrote:
>> On 2/5/26 17:41, Jason Gunthorpe wrote:
>>> On Tue, Feb 03, 2026 at 02:29:55PM +0000, Pavel Begunkov wrote:
>>>
>>>> The proposal consists of two parts. The first is a small in-kernel
>>>> framework that allows a dma-buf to be registered against a given file
>>>> and returns an object representing a DMA mapping.
>>>
>>> What is this about and why would you need something like this?
>>>
>>> The rest makes more sense - pass a DMABUF (or even memfd) to iouring
>>> and pre-setup the DMA mapping to get dma_addr_t, then directly use
>>> dma_addr_t through the entire block stack right into the eventual
>>> driver.
>>
>> That's more or less what I tried to do in v1, but 1) people didn't like
>> the idea of passing raw dma addresses directly, and having it wrapped
>> into a black box gives more flexibility like potentially supporting
>> multi-device filesystems.
> 
> Ok.. but what does that have to do with a user space visible file?

If you're referring to registration taking a file, it's used to forward
this registration to the right driver, which knows about devices and can
create dma-buf attachment[s]. The abstraction users get is not just a
buffer but rather a buffer registered for a "subsystem" represented by
the passed file. With nvme raw bdev as the only importer in the patch set,
it's simply converges to "registered for the file", but the notion will
need to be expanded later, e.g. to accommodate filesystems.

>> 2) dma-buf folks want dynamic attachments,
>> and it makes it quite a bit more complicated when you might be asked to
>> shoot down DMA mappings at any moment, so I'm isolating all that
>> into something that can be reused.
> 
> IMHO there is probably nothing really resuable here. The logic to
> fence any usage is entirely unique to whoever is using it, and the
> locking tends to be really hard.
> 
> You should review the email threads linked to this patch and all it's
> prior versions as the expected importer behavior for pinned dmabufs is
> not well understood.

I'm not pinning it (i.e. no dma_buf_pin()), it should be a fair
dynamic implementation. In short, It adds a fence on move_notify
and signals when all requests using it are gone. New requests will
be trying to create a new mapping (and wait for fences).

> https://lore.kernel.org/all/20260131-dmabuf-revoke-v7-0-463d956bd527@nvidia.com/
> 
>>>> Tushar was helping and mention he got good numbers for P2P transfers
>>>> compared to bouncing it via RAM.
>>>
>>> We can already avoid the bouncing, it seems the main improvements here
>>> are avoiding the DMA map per-io and allowing the use of P2P without
>>> also creating struct page. Meanginful wins for sure.
>>
>> Yes, and it should probably be nicer for frameworks that already
>> expose dma-bufs.
> 
> I'm not sure what this means?

I'm saying that when a user app can easily get or already has a
dma-buf fd, it should be easier to just use it instead of finding
its way to FOLL_PCI_P2PDMA. I'm actually curious, is there a way
to somehow create a MEMORY_DEVICE_PCI_P2PDMA mapping out of a random
dma-buf? From a quick glance, I only see nvme cmb and some accelerator
being registered to P2PDMA, but maybe I'm missing something.

-- 
Pavel Begunkov


