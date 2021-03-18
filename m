Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3724340D5B
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 19:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbhCRSmI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 14:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbhCRSlt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Mar 2021 14:41:49 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00CCC06174A
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 11:41:48 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id l5so5819902ilv.9
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 11:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=11LYuxy/PVwLEMc1x946PQMZwvGVf/5B86ZwRj/GhCY=;
        b=xaUFsauEvSSW8OgPR0s0fId++ugaBghEP0bCL6TFHaGZBPFgkM8gcZEujLVA12G5DB
         te1WFS7AfLVHXuCim90sYe2mlnqPA0GUBlV/xQel2wQhR0pwibXfIePJmXuvT2wvdzW3
         VShC57HJ1iTyNVSOGEw6mllLXUfPk5r1iL7nK5ePbdmgIjGcRWXsnxQPw6ijYFupBhYL
         /EolzsfArUhWWyCDFUio0GcW2L4uD6dN0DPA4LXWV7+MkeoJ3ui6D/pQT69BG1pxS2ZF
         8/X7UxRQnSVm9idEwGpQd7QJzD01Szy5e0++dzNO0Y8YIFmx6UG72Ud8anoYw5v+vW/v
         gvKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=11LYuxy/PVwLEMc1x946PQMZwvGVf/5B86ZwRj/GhCY=;
        b=RlPPWkR9Yjp7Y4fPfoHPQQFed2Wc/lXGdIOyyW3fmGaiOqWaDJGy8NHytzsgYu5BhP
         vLB5gcprrQMsi/FRxejg/uEavUIB7q2hAL/WQMKuHf6ceG5dfm3f9Meu6uLYNlSub0gW
         PXpL6AnKrGc8h19L0mJWAfkaP36qqV/1Ece9QfXJs9/f0mAJCMFlx2Fek/SMsv0Og+mP
         8nyw1dGae3g3LdXl40mAwTwgfE+IWk3GdMdlk3QaJQVAG66m8u8BVvcFLQLEjt4EQL4p
         RgmyhnVHX41x8HlgvcUwO06SjLco3qVNWeBAz4v9roUuNo5WAHDBuZf8ixaUNAcnsydp
         S+NQ==
X-Gm-Message-State: AOAM533ofAmZQfssBNMIk16PEFqrFsLWLtG8DGxzhK1GpztnwO1lLqak
        +d93mf1fUgkZogr/r43Ru6gZiw==
X-Google-Smtp-Source: ABdhPJy22yz7dLdT3KAF1l7QWugeAL2zR48qA3rXLsugi+uSzhGsn6+zKttK/WCBcCeNKtCIdHy46g==
X-Received: by 2002:a92:ce02:: with SMTP id b2mr13245416ilo.182.1616092908408;
        Thu, 18 Mar 2021 11:41:48 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k10sm1306669iop.42.2021.03.18.11.41.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 11:41:48 -0700 (PDT)
Subject: Re: [PATCH 3/8] fs: add file_operations->uring_cmd()
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com, kbusch@kernel.org,
        linux-nvme@lists.infradead.org, metze@samba.org
References: <20210317221027.366780-1-axboe@kernel.dk>
 <20210317221027.366780-4-axboe@kernel.dk> <20210318053832.GB28063@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6ef8634c-632c-2ddb-0e46-6469b659d27d@kernel.dk>
Date:   Thu, 18 Mar 2021 12:41:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210318053832.GB28063@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/17/21 11:38 PM, Christoph Hellwig wrote:
> On Wed, Mar 17, 2021 at 04:10:22PM -0600, Jens Axboe wrote:
>> This is a file private handler, similar to ioctls but hopefully a lot
>> more sane and useful.
> 
> I really hate defining the interface in terms of io_uring.  This really
> is nothing but an async ioctl.

Sure, it's generic, could potentially use any transport. But the way it's
currently setup is using an io_uring transport and embedded command.

>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index ec8f3ddf4a6a..009abc668987 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -1884,6 +1884,15 @@ struct dir_context {
>>  #define REMAP_FILE_ADVISORY		(REMAP_FILE_CAN_SHORTEN)
>>  
>>  struct iov_iter;
>> +struct io_uring_cmd;
>> +
>> +/*
>> + * f_op->uring_cmd() issue flags
>> + */
>> +enum io_uring_cmd_flags {
>> +	IO_URING_F_NONBLOCK		= 1,
>> +	IO_URING_F_COMPLETE_DEFER	= 2,
>> +};
> 
> I'm a little worried about exposing a complete io_uring specific
> concept like IO_URING_F_COMPLETE_DEFER to random drivers.  This
> needs to be better encapsulated.

Agree.

>>  struct file_operations {
>>  	struct module *owner;
>> @@ -1925,6 +1934,8 @@ struct file_operations {
>>  				   struct file *file_out, loff_t pos_out,
>>  				   loff_t len, unsigned int remap_flags);
>>  	int (*fadvise)(struct file *, loff_t, loff_t, int);
>> +
>> +	int (*uring_cmd)(struct io_uring_cmd *, enum io_uring_cmd_flags);
> 
> As of this patch io_uring_cmd is still a private structure.  In general
> I'm not sure this patch makes much sense on its own either.

Might indeed just fold it in or reshuffle, I'll take a look.

-- 
Jens Axboe

