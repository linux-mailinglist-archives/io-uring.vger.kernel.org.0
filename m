Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54ED75B3EE
	for <lists+io-uring@lfdr.de>; Thu, 20 Jul 2023 18:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjGTQNh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 12:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGTQNg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 12:13:36 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5694114
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 09:13:34 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-78706966220so9755639f.1
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 09:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689869614; x=1690474414;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7G5uQrnn6OsNRNeizmHDbdN7tLpWHjdqCoRzjzhMzXw=;
        b=k8cpQd9FLz/0upz3C+LmPe+KeJM26VeBi4YaVmelfBQDwYS3GhHOb4LU0U5JeKz0jJ
         qBOcqcpFcpgIAix02eCD29mNe/4Deq3jr7LQoFQyudLtoObjC8ZvJ/BzM/kNnvyeN4jl
         v7uaXFQ3OnNJQX8Sr/3xZwrCIEbd7G/G0a5mSVL3wtxyycH3B0I+7GfM2eZ7teQYtzBQ
         bWZMXm7RAQgBHfgRelS0tVLFu8cSs7FPRNnOPs7/PQJFDROwydjKezWVkom0BJ+VA9Se
         BXOzpXZEppiKQuWoBqf8Zj0oYA4YSWen3nMjDrYSQO6lUiWBg+ZRWOhBKe4IEDZ9QYsS
         wNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689869614; x=1690474414;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7G5uQrnn6OsNRNeizmHDbdN7tLpWHjdqCoRzjzhMzXw=;
        b=HW22TTGyEKkdxOlP0PDFzEmHM2ZY7pgNeS5LQCDG9d/QBW5thD8DbxeTlx0V6XjZS3
         aUzKoOohMLyXtBQ9/YocXASSF+wbmJJ3nF/GEUbpyIpHysTw/7gWEMOEdloe2VX7CGfX
         W7Hokzzak8nMPrzCPl4YgQonEk9qXTUVemdOBV8zFC48RS+gLfvVNMPUqIn6aBr1yNQt
         DgkbA6ip1W5iKJRKIiwzGSpo/nsa7QbPp2QNIul0y9SurOsH7ieS7stShXpr5AEpAB1y
         KZswvEL2zVeW15Ixt0e6sK1Nva3Rtz/vFDzHjsr+sWvVn83+NFNh6/TIGmolACOUYqpz
         YqGg==
X-Gm-Message-State: ABy/qLZSVhlnK25s4NXodVCvul7azAUrcno/VCBl1JU6jrhGHLVmaGat
        AWLO/xDYbFC1rJUytC83C+h43TYDu1HtvWhIYt4=
X-Google-Smtp-Source: APBJJlFgKuZzOjg+g6wpc5sEGwFBEPsT+0kdpFhZ5Ywas9oFGCFy+2tQPIH/ig3/CyxRw1VEK0z6Pw==
X-Received: by 2002:a05:6602:3710:b0:788:2d78:813c with SMTP id bh16-20020a056602371000b007882d78813cmr3298508iob.0.1689869614105;
        Thu, 20 Jul 2023 09:13:34 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t21-20020a02ab95000000b0042b62a31349sm408407jan.146.2023.07.20.09.13.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jul 2023 09:13:33 -0700 (PDT)
Message-ID: <5958f4f2-8722-08ac-53b2-e9e2f6903720@kernel.dk>
Date:   Thu, 20 Jul 2023 10:13:32 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/6] iomap: cleanup up iomap_dio_bio_end_io()
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org,
        andres@anarazel.de, david@fromorbit.com
References: <20230719195417.1704513-1-axboe@kernel.dk>
 <20230719195417.1704513-2-axboe@kernel.dk> <20230720045035.GA1811@lst.de>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230720045035.GA1811@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/19/23 10:50?PM, Christoph Hellwig wrote:
>> +	/*
>> +	 * Synchronous dio, task itself will handle any completion work
>> +	 * that needs after IO. All we need to do is wake the task.
>> +	 */
>> +	if (dio->wait_for_completion) {
>> +		struct task_struct *waiter = dio->submit.waiter;
>> +		WRITE_ONCE(dio->submit.waiter, NULL);
> 
> I know the existing code got it wrong, but can you please add an empty
> line after the variable declaration here?

Sure, will add.

>> +	/*
>> +	 * If this dio is an async write, queue completion work for async
>> +	 * handling. Reads can always complete inline.
>> +	 */
>> +	if (dio->flags & IOMAP_DIO_WRITE) {
>> +		struct inode *inode = file_inode(iocb->ki_filp);
>> +
>> +		WRITE_ONCE(iocb->private, NULL);
>> +		INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
>> +		queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
>> +	} else {
> 
> If we already do the goto style I'd probably do it here as well instead
> of the else.

It does end up like that later on, but I can do it earlier and leave the
least desirable method (workqueue) at the end from this patch.

-- 
Jens Axboe

