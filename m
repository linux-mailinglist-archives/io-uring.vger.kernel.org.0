Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0750F61F394
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 13:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbiKGMpc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 07:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbiKGMp3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 07:45:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4430D1AF30
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 04:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667825074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2hqgA/TRgZw1DzPVWmvs/bi2bDcerUKILSHp4k/Qv2I=;
        b=L2R7cTGvdJTMdEw4HziMLkFAxviTg0Os6F5twbcu/H/hBqCUqNG9/GhrqlEtQ0D6U5lEQy
        qdGCI66JXihtiRbnFzzDLekclBaS7vTUWLglpVFNmYeSdxMDgXqMGbTNZPR/SNyijUCF9H
        r9POiCSxaoFL9PWYY2oo5QFMD5pXICk=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-35-O9CUjeaMOui_kXPQ29eh8A-1; Mon, 07 Nov 2022 07:44:33 -0500
X-MC-Unique: O9CUjeaMOui_kXPQ29eh8A-1
Received: by mail-pg1-f197.google.com with SMTP id e128-20020a636986000000b0047075a1c725so1584931pgc.19
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 04:44:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2hqgA/TRgZw1DzPVWmvs/bi2bDcerUKILSHp4k/Qv2I=;
        b=p1/du4CJQg6ihgMZgMOEMCXL5GepSdaRYlYaLI4Sf3T2/iMgx0MwjLJkQEAFNTVl8a
         nJ0fpbvwx7cRhJNDkwX/gd/z88+mV1FnuDHvA5nnAsEcYBGgPuPLJufusdbty9ACgmHw
         okXXjiKdE6oVtPwtGu6Jnj56sb/A4k3oLI6/GqisLjx1zx/tuCJrSc4arSmnej2qjBsT
         5OrGntxFmkReEBVDKiqgxCYeRFo8mr0dw2DtAKF5Yq2LTB5OfLcvYVoFgrgvA1bSydU4
         P5IwBX1AWcB52ml9VauyFWVqisTx9wn7MW8GPdXTGZU2lVpvGx5xC7yiUyWwU2j6D6Vi
         /r9g==
X-Gm-Message-State: ACrzQf3Ed3w9snlikk770CHf039AMtnPFOfL8rIvrUB/Q4sjdGDOQ1Vy
        N/pQACB18ambhr5x4h4R8BEEaal1RyUgOXs/0YqKzVKfCxqUzltqVGB4MEo4BgLL9eqUIOh6qfP
        DJGyK/fa2+dLLcyfNg1c=
X-Received: by 2002:a05:6a00:21cc:b0:56c:ba99:795d with SMTP id t12-20020a056a0021cc00b0056cba99795dmr50314879pfj.84.1667825072140;
        Mon, 07 Nov 2022 04:44:32 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6Z8VizXTILvpkDYYRHc1gOLDg0bA5X+HhAJoGWKY3jU2FfCdpEd9AI46CqQAZaCoZ5DX+GxA==
X-Received: by 2002:a05:6a00:21cc:b0:56c:ba99:795d with SMTP id t12-20020a056a0021cc00b0056cba99795dmr50314862pfj.84.1667825071873;
        Mon, 07 Nov 2022 04:44:31 -0800 (PST)
Received: from [10.72.12.88] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id pv7-20020a17090b3c8700b00213c7cf21c0sm4240009pjb.5.2022.11.07.04.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 04:44:31 -0800 (PST)
Subject: Re: [RFC PATCH] fs/lock: increase the filp's reference for
 Posix-style locks
To:     Jeff Layton <jlayton@kernel.org>, viro@zeniv.linux.org.uk,
        chuck.lever@oracle.com
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, ceph-devel@vger.kernel.org,
        mchangir@redhat.com, idryomov@gmail.com, lhenriques@suse.de,
        gfarnum@redhat.com
References: <20221107095232.36828-1-xiubli@redhat.com>
 <2f1fe2fe57f39ab420c7855584ae7b6bb85a7692.camel@kernel.org>
 <c5a2cf05-8e30-1fac-3c48-d4b508ea9009@redhat.com>
 <88511dabbfb0cfad748100f59f2ce4025db29dc0.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b1333f15-fb3d-5698-1852-47a55546bdb8@redhat.com>
Date:   Mon, 7 Nov 2022 20:44:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <88511dabbfb0cfad748100f59f2ce4025db29dc0.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 07/11/2022 20:29, Jeff Layton wrote:
> On Mon, 2022-11-07 at 20:03 +0800, Xiubo Li wrote:
>> On 07/11/2022 18:33, Jeff Layton wrote:
>>> On Mon, 2022-11-07 at 17:52 +0800, xiubli@redhat.com wrote:
[...]
>>>> diff --git a/io_uring/openclose.c b/io_uring/openclose.c
>>>> index 67178e4bb282..5a12cdf7f8d0 100644
>>>> --- a/io_uring/openclose.c
>>>> +++ b/io_uring/openclose.c
>>>> @@ -212,6 +212,7 @@ int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>    int io_close(struct io_kiocb *req, unsigned int issue_flags)
>>>>    {
>>>>    	struct files_struct *files = current->files;
>>>> +	fl_owner_t owner = file_lock_make_thread_owner(files);
>>>>    	struct io_close *close = io_kiocb_to_cmd(req, struct io_close);
>>>>    	struct fdtable *fdt;
>>>>    	struct file *file;
>>>> @@ -247,7 +248,7 @@ int io_close(struct io_kiocb *req, unsigned int issue_flags)
>>>>    		goto err;
>>>>    
>>>>    	/* No ->flush() or already async, safely close from here */
>>>> -	ret = filp_close(file, current->files);
>>>> +	ret = filp_close(file, owner);
>>>>    err:
>>>>    	if (ret < 0)
>>>>    		req_set_fail(req);
>>> I think this is the wrong approach to fixing this. It also looks like
>>> you could hit a similar problem with OFD locks and this patch wouldn't
>>> address that issue.
>> For the OFD locks they will set the 'file' struct as the owner just as
>> the flock does, it should be okay and I don't think it has this issue if
>> my understanding is correct here.
>>
> They set the the owner to "file", but they don't hold a reference to it.
> With OFD locks, the file is what holds references to the lock, not the
> reverse.

Yeah, right. But for both OFD and flock they shouldn't hit this issue, 
because it when removing all the locks having the same owner, which is 
the 'file', passed by filp_close(filp), the 'file' reference counter 
must be larger than 0. Because the filp_close() is still using it.

This is why using the thread id as the owner is a special case for 
Posix-style lock.

>
>>> The real bug seems to be that ceph_fl_release_lock dereferences fl_file,
>>> at a point when it shouldn't rely on that being valid. Most filesystems
>>> stash some info in fl->fl_u if they need to do bookkeeping after
>>> releasing a lock. Perhaps ceph should be doing something similar?
>> This is the 'filp' memory in filp_close(filp, ...):
>>
>> crash> file.f_path.dentry,f_inode 0xffff952d7ab46200
>>     f_path.dentry = 0xffff9521b121cb40
>>     f_inode = 0xffff951f3ea33550,
>>
>> We can see the 'f_inode' is pointing to the correct inode memory.
>>
>>
>>
>> While later in 'ceph_fl_release_lock()':
>>
>> 41 static void ceph_fl_release_lock(struct file_lock *fl)
>> 42 {
>> 43     struct ceph_file_info *fi = fl->fl_file->private_data;
>> 44     struct inode *inode = file_inode(fl->fl_file);
>> 45     struct ceph_inode_info *ci = ceph_inode(inode);
>> 46     atomic_dec(&fi->num_locks);
>> 47     if (atomic_dec_and_test(&ci->i_filelock_ref)) {
>> 48         /* clear error when all locks are released */
>> 49         spin_lock(&ci->i_ceph_lock);
>> 50         ci->i_ceph_flags &= ~CEPH_I_ERROR_FILELOCK;
>> 51         spin_unlock(&ci->i_ceph_lock);
>> 52     }
>> 53 }
>>
> You only need the inode for most of this. The exception is
> fi->num_locks, so you may need to test for that in a different way.
>
>> It crashed in Line#47 and the 'fl->fl_file' memory is:
>>
>> crash> file.f_path.dentry,f_inode 0xffff952d4ebd8a00
>>     f_path.dentry = 0x0
>>     f_inode = 0x0,
>>
>> Please NOTE: the 'filp' and 'fl->fl_file' are two different 'file struct'.
>>
> Yep, I understand the bug. I just don't like the proposed fix. :)

Yeah, I also think this approach is ugly :-)

>> Can we fix this by using 'fl->fl_u' here ?
>>
> Probably. You could take and hold an inode reference in there, and maybe
> add a function that looks at whether there are any locks held against a
> particular file, rather than trying to count locks in ceph_file_info.

Okay, this sounds good.

Let me try this tomorrow.

>> I was also thinking I could just call the 'get_file(file)' in
>> ceph_lock() and then in ceph_fl_release_lock() release the reference
>> counter. How about this ?
>>
> That may work too, though again, I'd be worried about cyclical
> dependencies, particularly with OFD locks. If the lock holds a reference
> to the file, then can the file's refcount ever go to zero if the lock is
> never explicitly released? I think not.
>
> You may also need to consider flock locks too, since they have similar
> ownership semantics to OFD locks.

I will send a V2 later.

Thanks Jeff!

- Xiubo


