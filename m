Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A7A74FBED
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 01:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjGKXuf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 19:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjGKXue (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 19:50:34 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256791711
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 16:50:30 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-25e847bb482so1232240a91.1
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 16:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689119429; x=1691711429;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aiChzLIu4UI9ZVqSfbNGHYHUHgFyI0kwzHwtS3oE6/w=;
        b=ZQ9B5qBfzjmSTaLQE2e9dnWN9wcsxvVcj8f8FnNcNazzsa/b2Nlamrj6UrZuT/PZXT
         bWKTkwrGqi6D1qukB2iu4jfZXoq2mTH5BM3YzAOyEXJxxNSoa9KwQa4+HypqTjfz8NmZ
         0A3JhQQBG8uUK1IAZcVqExVi43JzHEDd6Hfs+7IgjLPagJYCcdgZ4EAalj9eCfzCWKJ0
         UCH9O/bFRIkV/E6936HNCE2ytaBu8UV+unHBc58lDKEd+pNLr6AqozjItcD3dIeL+CAQ
         cTsyhSOOsDafDn5O99u9GmPJ3ow/IS6xXH9v0A5rDyuOrlTuj5A4+Np7mHbuo6hrJ/+P
         6TFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689119429; x=1691711429;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aiChzLIu4UI9ZVqSfbNGHYHUHgFyI0kwzHwtS3oE6/w=;
        b=Lg9KH1Jr3Qh5oAUTsCKxf1G/NCTuaYo5EN2UNgWkFjtA7vKz32UK3LM//GaOsxHfao
         Dj4Fz4Ri3ARNEN0Z5HNUMvnmyRvYqB/lTf5AM8otHvYmnCynp4Ies397GdiUXFExFuX2
         F2pfxnJIdcyKSd3Hfz9hMyEWYQ2Ogg73QvmU5T4C2uAM4WPBzRtufs3uxbUYp2nSnZbx
         YnnsGQQHeGHpqaWpEkYmUEbPlyTkl3tR++a1Pn7U2M+VmNyB1OC3f4q3KpO39t5HOJVy
         jp4+DWnmDfAu5IqAKBstz4MNtExaX/oEDWmedA2TfoQLSb2T9wr/+Xhpwn9x9BYaUANW
         uB4g==
X-Gm-Message-State: ABy/qLYugmaeQXOkhRGBOCACPckbD+GfMRS+mxOb/9kTwkua/IL/tX6p
        g6O3YfErgVsOhzQVJuzaWrQXJaCtmvc41amykoQ=
X-Google-Smtp-Source: APBJJlFj4LN6wQDRW6/DelE0V+uxfv7FDqMQoP4+Eci1hR8gi7t69IBQt15l0r2AMeFakDF4LzOCuA==
X-Received: by 2002:a17:90a:840d:b0:263:5c30:2cf8 with SMTP id j13-20020a17090a840d00b002635c302cf8mr16996559pjn.0.1689119429559;
        Tue, 11 Jul 2023 16:50:29 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q4-20020a17090a4f8400b00264c262a033sm9399120pjh.12.2023.07.11.16.50.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 16:50:28 -0700 (PDT)
Message-ID: <7fa7d7fc-9a92-f48e-3535-b503f5689103@kernel.dk>
Date:   Tue, 11 Jul 2023 17:50:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/3] fs: split off vfs_getdents function of getdents64
 syscall
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>, Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <20230711114027.59945-2-hao.xu@linux.dev>
 <ZK3owSS5eENdH7YZ@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZK3owSS5eENdH7YZ@dread.disaster.area>
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

On 7/11/23 5:41?PM, Dave Chinner wrote:
> On Tue, Jul 11, 2023 at 07:40:25PM +0800, Hao Xu wrote:
>> From: Dominique Martinet <asmadeus@codewreck.org>
>>
>> This splits off the vfs_getdents function from the getdents64 system
>> call.
>> This will allow io_uring to call the vfs_getdents function.
>>
>> Co-developed-by: Stefan Roesch <shr@fb.com>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
>> ---
>>  fs/internal.h |  8 ++++++++
>>  fs/readdir.c  | 34 ++++++++++++++++++++++++++--------
>>  2 files changed, 34 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/internal.h b/fs/internal.h
>> index f7a3dc111026..b1f66e52d61b 100644
>> --- a/fs/internal.h
>> +++ b/fs/internal.h
>> @@ -304,3 +304,11 @@ ssize_t __kernel_write_iter(struct file *file, struct iov_iter *from, loff_t *po
>>  struct mnt_idmap *alloc_mnt_idmap(struct user_namespace *mnt_userns);
>>  struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap);
>>  void mnt_idmap_put(struct mnt_idmap *idmap);
>> +
>> +/*
>> + * fs/readdir.c
>> + */
>> +struct linux_dirent64;
>> +
>> +int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
>> +		 unsigned int count);
> 
> Uh...
> 
> Since when have we allowed code outside fs/ to use fs/internal.h?

io_uring does use for things like open/close, statx, and xattr already.

-- 
Jens Axboe

