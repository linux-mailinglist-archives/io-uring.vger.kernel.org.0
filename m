Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5064C5AB504
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 17:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbiIBPYm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 11:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbiIBPYT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 11:24:19 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE3E17860B
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 07:57:33 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id v15so1262839iln.6
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 07:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=/bAWXX/7J+H5d6R7FI3fLen6Yfws6WpUi6HxyLc66uM=;
        b=7kovIplH/o5Cx577vNwne34TTjRkgIydxYNjssJPG9zjoAjHVOhbZfvkFPCFo2p6b6
         n2Wk7IJWRSdoOMvmAesoN1GWeUqffShkPTGu2si1nuUHywyx+0KqJFM349zafvu0yv9f
         JyK8bfxUJ6gHOE6UYcDCqb3KStjq1QXRulPgwih97m4WIf8ugxr8YSu56zmi30jkTdlp
         Wfquca+BcdMPtnRbjulpzeKWiTaBiEoNm/qXOtuArHT6YOWFHPBihY6kgZkv5xhD6Fna
         LADjUhUTNHzbhTuZm6EjLaXwY/q4RSbGlktBmcwOZn8VUlM2+ugwWWLHlsprlarZXjWU
         Si7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=/bAWXX/7J+H5d6R7FI3fLen6Yfws6WpUi6HxyLc66uM=;
        b=mFKW8PDH99CEkTQaPvXYZFo4LGsG8zOPBpvneJzRzLJA7shLTS84HBxMZE2UP8pkZj
         dBuuRwmLllsDk3bdA7XIzjKIQrlAqt0g7TsYVmWF4j9wcMj0Ty2qckyvjmJFcCGRhC8m
         u0C1ogKwy5a0y2fszOXOCn7tIpBgRClR0clla+gmfO46djvtYTo6hgc3t7DwGI3eoRzU
         HitdipdcZiTIGFiEzWa4IURwfdPjneL7Ha37rB+M/epJh6MNYLFPHbAlRgSTtjh3wsFq
         o9y7Ij+CT3FyDCpsMfCfTVpFpUjaFiBXF103snb5pBzY++Im7WSWkD3KBCgknwyC0YSO
         SoLg==
X-Gm-Message-State: ACgBeo0PIM7K0qeSOtEKSZ5B5srFMCIkdhavNRF0B41JA4zpsK91MS5R
        02rhVKkqNUhYjwnWhySzvx5fDQ==
X-Google-Smtp-Source: AA6agR4GGI2x59eUmF2Gvit+G1nEJL05jF1JEhDKdlMsAsZc+Z+MORQPdNBEv9LPz5WZz3WyN30F3A==
X-Received: by 2002:a05:6e02:214b:b0:2ec:f24f:5272 with SMTP id d11-20020a056e02214b00b002ecf24f5272mr4137723ilv.169.1662130650414;
        Fri, 02 Sep 2022 07:57:30 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m3-20020a0566022e8300b0068226bcb7aasm918685iow.38.2022.09.02.07.57.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 07:57:29 -0700 (PDT)
Message-ID: <d42ec471-b67f-6504-72bf-8bbc761ac3e7@kernel.dk>
Date:   Fri, 2 Sep 2022 08:57:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v1 01/10] btrfs: implement a nowait option for tree
 searches
Content-Language: en-US
To:     fdmanana@gmail.com, Stefan Roesch <shr@fb.com>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, josef@toxicpanda.com
References: <20220901225849.42898-1-shr@fb.com>
 <20220901225849.42898-2-shr@fb.com>
 <CAL3q7H7Xm+HkUXE6zeT+0fH+9Hi9XhE7gXH7mYcGeAoYR5D2XQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAL3q7H7Xm+HkUXE6zeT+0fH+9Hi9XhE7gXH7mYcGeAoYR5D2XQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/22 8:48 AM, Filipe Manana wrote:
> On Fri, Sep 2, 2022 at 12:01 AM Stefan Roesch <shr@fb.com> wrote:
>>
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> For NOWAIT IOCB's we'll need a way to tell search to not wait on locks
>> or anything.  Accomplish this by adding a path->nowait flag that will
>> use trylocks and skip reading of metadata, returning -EWOULDBLOCK in
>> either of these cases.  For now we only need this for reads, so only the
>> read side is handled.  Add an ASSERT() to catch anybody trying to use
>> this for writes so they know they'll have to implement the write side.
>>
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/btrfs/ctree.c   | 39 ++++++++++++++++++++++++++++++++++++---
>>  fs/btrfs/ctree.h   |  1 +
>>  fs/btrfs/locking.c | 23 +++++++++++++++++++++++
>>  fs/btrfs/locking.h |  1 +
>>  4 files changed, 61 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index ebfa35fe1c38..052c768b2297 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -1447,6 +1447,11 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
>>                         return 0;
>>                 }
>>
>> +               if (p->nowait) {
>> +                       free_extent_buffer(tmp);
>> +                       return -EWOULDBLOCK;
>> +               }
>> +
>>                 if (unlock_up)
>>                         btrfs_unlock_up_safe(p, level + 1);
>>
>> @@ -1467,6 +1472,8 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
>>                         ret = -EAGAIN;
>>
>>                 goto out;
>> +       } else if (p->nowait) {
>> +               return -EWOULDBLOCK;
>>         }
>>
>>         if (unlock_up) {
>> @@ -1634,7 +1641,13 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
>>                  * We don't know the level of the root node until we actually
>>                  * have it read locked
>>                  */
>> -               b = btrfs_read_lock_root_node(root);
>> +               if (p->nowait) {
>> +                       b = btrfs_try_read_lock_root_node(root);
>> +                       if (IS_ERR(b))
>> +                               return b;
>> +               } else {
>> +                       b = btrfs_read_lock_root_node(root);
>> +               }
>>                 level = btrfs_header_level(b);
>>                 if (level > write_lock_level)
>>                         goto out;
>> @@ -1910,6 +1923,13 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>>         WARN_ON(p->nodes[0] != NULL);
>>         BUG_ON(!cow && ins_len);
>>
>> +       /*
>> +        * For now only allow nowait for read only operations.  There's no
>> +        * strict reason why we can't, we just only need it for reads so I'm
>> +        * only implementing it for reads right now.
>> +        */
>> +       ASSERT(!p->nowait || !cow);
>> +
>>         if (ins_len < 0) {
>>                 lowest_unlock = 2;
>>
>> @@ -1936,7 +1956,12 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>>
>>         if (p->need_commit_sem) {
>>                 ASSERT(p->search_commit_root);
>> -               down_read(&fs_info->commit_root_sem);
>> +               if (p->nowait) {
>> +                       if (!down_read_trylock(&fs_info->commit_root_sem))
>> +                               return -EAGAIN;
> 
> Why EAGAIN here and everywhere else EWOULDBLOCK? See below.

Is EWOULDBLOCK ever different from EAGAIN? But it should be used
consistently, EAGAIN would be the return of choice for that.

-- 
Jens Axboe
