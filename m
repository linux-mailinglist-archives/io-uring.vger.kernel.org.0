Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693427BC7F2
	for <lists+io-uring@lfdr.de>; Sat,  7 Oct 2023 15:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbjJGNLp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Oct 2023 09:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjJGNLo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Oct 2023 09:11:44 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA9FC2
        for <io-uring@vger.kernel.org>; Sat,  7 Oct 2023 06:11:42 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-693400e09afso765567b3a.1
        for <io-uring@vger.kernel.org>; Sat, 07 Oct 2023 06:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696684301; x=1697289101; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ca4YeJ2DLaYsOGwO/0MihJc3GRRS7TJuq5FqieD0IEM=;
        b=jL5Wu4iL8G6XnYhq9FnV/hd0bQycXk3t8ZnxVbr/6H5LSzDMFAfhy5x/gwtzcbHlXY
         uO5rPiFVGN49Mb7QrFJumzXDQP6GOa/70I6nlr7EgK/qyzEkapJMhuOHYx90xBB1Ajd0
         ePOfFlZefghYxuaUNc0zy1M03UKX62ClH7DsTyZcqzphv2Gj7EhUYrbJFvU5bnmHNbG+
         FvPgqVk3yAsgU6nQMlNoc3T5jqF4w6PJF8HLeBPm7qhysl81u8kPGAs6CXlqAHRi1102
         7Mzkcj4M9231vaKcG343B6EVhMmYayM91sBItHMHJTxeeoP0tVDgFTglRu2rVPMRMY67
         foHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696684301; x=1697289101;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ca4YeJ2DLaYsOGwO/0MihJc3GRRS7TJuq5FqieD0IEM=;
        b=cLbXDUOTgvIfZiBBgesk5oN1TZHjqFblOg9XW5aIJEmu1uQieoSUTPQvn5ApMOQ84w
         +oLMhHyaE8RfLFsjvQGwYbRodz+EC6XdttGvMMP43jmB4cfkMPwTJc+pLtqM4lEP8yIh
         dBr7cZY/l9MQu6FNp5CoYHg1yl4g1e9O20b+7vkgzTcCENFzf2rvLcppc7jVizHjYiHL
         58p6PyEnf0B0zvoRK5w8KQdNqAOc6KvEjLIYn+5z8xWB+wsLTvjNW7uQApdpJw9PqK79
         qAjeTkGCVxyDlx8n+IXhs+ckaSwrAGtjMgtZV9mg4suMpNQwe9VyYByG3YIbvPu2WaB4
         mMQA==
X-Gm-Message-State: AOJu0Yy1YpKv2RBEOdUkkfML/Twn8L51+7/0n4GAFZ+bDj7ByDfNwGa8
        YV7qhaegxawmIFsNw6Ax8dAxXA==
X-Google-Smtp-Source: AGHT+IGXkUprzQ+aBzAbPIR0AAjGTWfKW9B1FptWyEqyWx1LVz/YkVYz7f6mZOGdQHZYSLnGzwXU6Q==
X-Received: by 2002:a05:6a21:789a:b0:159:f5fb:bf74 with SMTP id bf26-20020a056a21789a00b00159f5fbbf74mr12535446pzc.3.1696684301401;
        Sat, 07 Oct 2023 06:11:41 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id j5-20020a17090aeb0500b0026f90d7947csm5036013pjz.34.2023.10.07.06.11.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Oct 2023 06:11:40 -0700 (PDT)
Message-ID: <e0307260-c438-41d9-97ec-563e9932a60e@kernel.dk>
Date:   Sat, 7 Oct 2023 07:11:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: audit: io_uring openat triggers audit reference count underflow
 in worker thread
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Dan Clash <Dan.Clash@microsoft.com>,
        "audit@vger.kernel.org" <audit@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     "paul@paul-moore.com" <paul@paul-moore.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <MW2PR2101MB1033FFF044A258F84AEAA584F1C9A@MW2PR2101MB1033.namprd21.prod.outlook.com>
 <ab758860-e51e-409c-8353-6205fbe515dc@kernel.dk>
In-Reply-To: <ab758860-e51e-409c-8353-6205fbe515dc@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/6/23 8:32 PM, Jens Axboe wrote:
> On 10/6/23 2:09 PM, Dan Clash wrote:
>> diff --git a/fs/namei.c b/fs/namei.c
>> index 2a8baa6ce3e8..4f7ac131c9d1 100644
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -187,7 +187,7 @@ getname_flags(const char __user *filename, int flags, int *empty)
>>  		}
>>  	}
>>
>> -	result->refcnt = 1;
>> +	refcount_set(&result->refcnt, 1);
>>  	/* The empty path is special. */
>>  	if (unlikely(!len)) {
>>  		if (empty)
>> @@ -248,7 +248,7 @@ getname_kernel(const char * filename)
>>  	memcpy((char *)result->name, filename, len);
>>  	result->uptr = NULL;
>>  	result->aname = NULL;
>> -	result->refcnt = 1;
>> +	refcount_set(&result->refcnt, 1);
>>  	audit_getname(result);
>>
>>  	return result;
>> @@ -259,9 +259,10 @@ void putname(struct filename *name)
>>  	if (IS_ERR(name))
>>  		return;
>>
>> -	BUG_ON(name->refcnt <= 0);
>> +	BUG_ON(refcount_read(&name->refcnt) == 0);
>> +	BUG_ON(refcount_read(&name->refcnt) == REFCOUNT_SATURATED);
>>
>> -	if (--name->refcnt > 0)
>> +	if (!refcount_dec_and_test(&name->refcnt))
>>  		return;
>>
>>  	if (name->name != name->iname) {
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index d0a54e9aac7a..8217e07726d4 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -2719,7 +2719,7 @@ struct audit_names;
>>  struct filename {
>>  	const char		*name;	/* pointer to actual string */
>>  	const __user char	*uptr;	/* original userland pointer */
>> -	int			refcnt;
>> +	refcount_t		refcnt;
>>  	struct audit_names	*aname;
>>  	const char		iname[];
>>  };
>> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
>> index 37cded22497e..232e0be9f6d9 100644
>> --- a/kernel/auditsc.c
>> +++ b/kernel/auditsc.c
>> @@ -2188,7 +2188,7 @@ __audit_reusename(const __user char *uptr)
>>  		if (!n->name)
>>  			continue;
>>  		if (n->name->uptr == uptr) {
>> -			n->name->refcnt++;
>> +			refcount_inc(&n->name->refcnt);
>>  			return n->name;
>>  		}
>>  	}
>> @@ -2217,7 +2217,7 @@ void __audit_getname(struct filename *name)
>>  	n->name = name;
>>  	n->name_len = AUDIT_NAME_FULL;
>>  	name->aname = n;
>> -	name->refcnt++;
>> +	refcount_inc(&name->refcnt);
>>  }
>>
>>  static inline int audit_copy_fcaps(struct audit_names *name,
>> @@ -2349,7 +2349,7 @@ void __audit_inode(struct filename *name, const struct dentry *dentry,
>>  		return;
>>  	if (name) {
>>  		n->name = name;
>> -		name->refcnt++;
>> +		refcount_inc(&name->refcnt);
>>  	}
>>
>>  out:
>> @@ -2474,7 +2474,7 @@ void __audit_inode_child(struct inode *parent,
>>  		if (found_parent) {
>>  			found_child->name = found_parent->name;
>>  			found_child->name_len = AUDIT_NAME_FULL;
>> -			found_child->name->refcnt++;
>> +			refcount_inc(&found_child->name->refcnt);
>>  		}
>>  	}
> 
> I'm not fully aware of what audit is doing with struct filename outside
> of needing it for the audit log. Rather than impose the atomic
> references for everyone, would it be doable to simply dupe the struct
> instead of grabbing the (non-atomic) reference to the existing one?
> 
> If not, since there's no over/underflow handling right now, it'd
> certainly be cheaper to use an atomic_t here rather than a full
> refcount.

After taking a closer look at this, I think the best course of action
would be to make the struct filename refcnt and atomic_t. With audit in
the picture, it's quite possible to have multiple threads manipulating
the filename refcnt at the same time, which is obviously not currently
safe.

Dan, would you mind sending that as a patch? Include a link to your
original email:

Link: https://lore.kernel.org/lkml/MW2PR2101MB1033FFF044A258F84AEAA584F1C9A@MW2PR2101MB1033.namprd21.prod.outlook.com/

and a Fixes tag as well:

Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")

and CC linux-fsdevel@vger.kernel.org and
Christian Brauner <brauner@kernel.org> as well.

Thanks!

-- 
Jens Axboe

