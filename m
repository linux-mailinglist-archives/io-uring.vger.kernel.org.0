Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB681340D51
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 19:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbhCRSkc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 14:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbhCRSk0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Mar 2021 14:40:26 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF61C06174A
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 11:40:26 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id l5so5816091ilv.9
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 11:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ONx/uzdjfT0b5DHLqgA8kDbyHozHRRxaNQcXVrCxzSU=;
        b=0y6dXe4TfriBKq4GhmgaKg+aFdpyDIGsEHZT2scZlEX2DtP0M2ztbnLtIt3EWgUXZW
         N+isKVmpQ+0COSV0Pqlp2jsI2DgIhqJWaV4T+or+KC/aIh1vQcLPsYuW+mJR+OXYT21c
         soU7faQAFj0cQq9mDxr9sKsVHDcmZfP+A8MgonApfixEt0dbU/L2mj3YiBjZwGqKWV1D
         NdmZkYX49ZhN/jmjvnvpp6hiQaYG/O3UD7BA3+yOm7E5qI7c4V3ce2RFviIrl8AN3dXc
         S2+IKNOaPPjCs4ThaOGO8VIEFWx/c7A3yMqLHUHrD7gxQ7+fPtroq5nKT02ABmHkjBF8
         DYtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ONx/uzdjfT0b5DHLqgA8kDbyHozHRRxaNQcXVrCxzSU=;
        b=VbjdHTqU0sFgHWyYOY3aUy22Y+CdyUh91IBfvogftYZiG4xs3LBda5se2hj7RNj/FS
         o40G4fy6XeyVQaAJiVxtXWQLBw8ieSmP4fg8MiLMyHn2UqQZ8m+0tqEMEfLIPjftXlsX
         059+74k7fv9TfwQscXGPqif4uddFdju3dUCdI2eBX+B7LzDt/qAptIWqHXBIPvjuXgy0
         uUaNxy9KidXwzgW7yiIczhqwvtWzAgT7Y8n5RF/rypEuVWr3nsDXoPumVogIQwpmVVxM
         91DjOleg2lKBipcR84UZWDdfAHmt2iT7cwISLx/GEkFes8OpGgy/G/eA3EvONnrSSaMR
         nUpQ==
X-Gm-Message-State: AOAM530+64E94yTSWdBzq/VdiEZ3wcAwQmfe4a2GU8aevaW2KoM1cMr6
        jfZkknwsJUbOWRoXvyQLJOHISg==
X-Google-Smtp-Source: ABdhPJx6IXZSAgKiTd5lTyzyPSnE2BiuN3Qv1SYrRqae1YoDrpXgAh9ktmMN8ocox9sIR8gyLPGfdw==
X-Received: by 2002:a92:d58a:: with SMTP id a10mr3275904iln.63.1616092826256;
        Thu, 18 Mar 2021 11:40:26 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t5sm1423125ilm.69.2021.03.18.11.40.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 11:40:25 -0700 (PDT)
Subject: Re: [PATCH 1/8] io_uring: split up io_uring_sqe into hdr + main
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com, kbusch@kernel.org,
        linux-nvme@lists.infradead.org, metze@samba.org
References: <20210317221027.366780-1-axboe@kernel.dk>
 <20210317221027.366780-2-axboe@kernel.dk> <20210318053454.GA28063@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <04ffff78-4a34-0848-4131-8b3cfd9a24f7@kernel.dk>
Date:   Thu, 18 Mar 2021 12:40:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210318053454.GA28063@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/17/21 11:34 PM, Christoph Hellwig wrote:
>> @@ -14,11 +14,22 @@
>>  /*
>>   * IO submission data structure (Submission Queue Entry)
>>   */
>> +struct io_uring_sqe_hdr {
>> +	__u8	opcode;		/* type of operation for this sqe */
>> +	__u8	flags;		/* IOSQE_ flags */
>> +	__u16	ioprio;		/* ioprio for the request */
>> +	__s32	fd;		/* file descriptor to do IO on */
>> +};
>> +
>>  struct io_uring_sqe {
>> +#ifdef __KERNEL__
>> +	struct io_uring_sqe_hdr	hdr;
>> +#else
>>  	__u8	opcode;		/* type of operation for this sqe */
>>  	__u8	flags;		/* IOSQE_ flags */
>>  	__u16	ioprio;		/* ioprio for the request */
>>  	__s32	fd;		/* file descriptor to do IO on */
>> +#endif
>>  	union {
>>  		__u64	off;	/* offset into file */
>>  		__u64	addr2;
> 
> Please don't do that ifdef __KERNEL__ mess.  We never guaranteed
> userspace API compatbility, just ABI compatibility.

Right, but I'm the one that has to deal with the fallout. For the
in-kernel one I can skip the __KERNEL__ part, and the layout is the
same anyway.

> But we really do have a biger problem here, and that is ioprio is
> a field that is specific to the read and write commands and thus
> should not be in the generic header.  On the other hand the
> personality is.
> 
> So I'm not sure trying to retrofit this even makes all that much sense.
> 
> Maybe we should just define io_uring_sqe_hdr the way it makes
> sense:
> 
> struct io_uring_sqe_hdr {
> 	__u8	opcode;	
> 	__u8	flags;
> 	__u16	personality;
> 	__s32	fd;
> 	__u64	user_data;
> };
> 
> and use that for all new commands going forward while marking the
> old ones as legacy.
> 
> io_uring_cmd_sqe would then be:
> 
> struct io_uring_cmd_sqe {
>         struct io_uring_sqe_hdr	hdr;
> 	__u33			ioc;
> 	__u32 			len;
> 	__u8			data[40];
> };
> 
> for example.  Note the 32-bit opcode just like ioctl to avoid
> getting into too much trouble due to collisions.

I was debating that with myself too, it's essentially making
the existing io_uring_sqe into io_uring_sqe_v1 and then making a new
v2 one. That would impact _all_ commands, and we'd need some trickery
to have newly compiled stuff use v2 and have existing applications
continue to work with the v1 format. That's very different from having
a single (or new) opcodes use a v2 format, effectively.

Looking into the feasibility of this. But if that is done, there are
other things that need to be factored in, as I'm not at all interested
in having a v3 down the line as well. And I'd need to be able to do this
seamlessly, both from an application point of view, and a performance
point of view (no stupid conversions inline).

Things that come up when something like this is on the table

- Should flags be extended? We're almost out... It hasn't been an
  issue so far, but seems a bit silly to go v2 and not at least leave
  a bit of room there. But obviously comes at a cost of losing eg 8
  bits somewhere else.

- Is u8 enough for the opcode? Again, we're nowhere near the limits
  here, but eventually multiplexing might be necessary.

That's just off the top of my head, probably other things to consider
too.

-- 
Jens Axboe

