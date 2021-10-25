Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CC44394CE
	for <lists+io-uring@lfdr.de>; Mon, 25 Oct 2021 13:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhJYL3I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Oct 2021 07:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbhJYL3I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Oct 2021 07:29:08 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D07AC061745;
        Mon, 25 Oct 2021 04:26:46 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id y12so18493405eda.4;
        Mon, 25 Oct 2021 04:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qN1ntwpd499TNlOQ/UEZDAqpHunyI7A/nMplokfVOKQ=;
        b=N7g17uCJxfPNDnN89p/XSrGO3jjyvj16ZwJ5MYCmn1cXk2EQ/gRPj8UGyNhXnpJxwN
         niqZEaxGHsEojm59LE8BNYyG/cZV1LKT02lvozn77SEnStWXYxJTRaJE2KfuufUqRSH9
         3iRPzLKYaCjeWj2/1KqZx54PsHNcSPoqK4rLI6Kn+nI94V/CJC0EyFFIil/iKuNyZ6s6
         oGzq66S1AGkyEXq6WaU6RBdgyO1Mjc8mNbT0ec7WvA1VQxvq4p9Vf8ZMiL5erwiHf5OG
         G3ajI8GhRSn/fzV58FI62AWBj7mTofNOHiRUScJ2gpLkwdxK+UQ5lLDwLl2RPvGrAjjS
         rzLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qN1ntwpd499TNlOQ/UEZDAqpHunyI7A/nMplokfVOKQ=;
        b=PjIET+sFGFxEPzFdQX3QTUN7Q0HBEec2SmhSjpEmX1OE6L5+F4nKFo5RD36FmE327h
         Md7hJJEwx82tX59KClSmAZd5LsCpRFGOHcD1FdM0MbmTgdFQmVdcYGoepVE6Dainxril
         xk361k+FJyz6QvXPnwd83WdxvFIOENgWERnEuPH7BrpmrNsMsuC4DPF0LFGC/NgsVQJq
         BMQbNN9GGskyC5a5MkdOdVI0/cwIuLL5IfNYNbAs/jtia5W0tj527TaDqnNvhWwqXUaD
         JB9B1Cis6rPnZGhVqyCwQkZBIB7ICNZ3oY59pHqnlCakg3Nb03Gn1uu5deybDKy3ahim
         0yZw==
X-Gm-Message-State: AOAM5334sQXGV9naJAtwCiBL7UudT3NSI6Ax1WwhHhyJVIe83weWig5i
        WEZUa5pt+/20zt3E+zYLUA4=
X-Google-Smtp-Source: ABdhPJxW0eshHVvkxjUoD6lhoo0qCrB7Hw8QH6SfkmfGoWTnJ7VZwcqdcxQyRvLPSGDbjDIgS9uksQ==
X-Received: by 2002:a17:906:b097:: with SMTP id x23mr21342956ejy.501.1635161204467;
        Mon, 25 Oct 2021 04:26:44 -0700 (PDT)
Received: from [192.168.8.198] ([185.69.144.165])
        by smtp.gmail.com with ESMTPSA id m1sm7414483ejn.121.2021.10.25.04.26.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 04:26:44 -0700 (PDT)
Message-ID: <23555381-2bea-f63a-1715-a80edd3ee27f@gmail.com>
Date:   Mon, 25 Oct 2021 12:25:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: uring regression - lost write request
Content-Language: en-US
To:     Daniel Black <daniel@mariadb.org>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <CABVffENnJ8JkP7EtuUTqi+VkJDBFU37w1UXe4Q3cB7-ixxh0VA@mail.gmail.com>
 <77f9feaa-2d65-c0f5-8e55-5f8210d6a4c6@gmail.com>
 <8cd3d258-91b8-c9b2-106c-01b577cc44d4@gmail.com>
 <CABVffEOMVbQ+MynbcNfD7KEA5Mwqdwm1YuOKgRWnpySboQSkSg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CABVffEOMVbQ+MynbcNfD7KEA5Mwqdwm1YuOKgRWnpySboQSkSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/25/21 12:09, Daniel Black wrote:
> On Mon, Oct 25, 2021 at 8:59 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 10/22/21 10:10, Pavel Begunkov wrote:
>>> On 10/22/21 04:12, Daniel Black wrote:
>>>> Sometime after 5.11 and is fixed in 5.15-rcX (rc6 extensively tested
>>>> over last few days) is a kernel regression we are tracing in
>>>> https://jira.mariadb.org/browse/MDEV-26674 and
>>>> https://jira.mariadb.org/browse/MDEV-26555
>>>> 5.10 and early across many distros and hardware appear not to have a problem.
>>>>
>>>> I'd appreciate some help identifying a 5.14 linux stable patch
>>>> suitable as I observe the fault in mainline 5.14.14 (built
>>>
>>> Cc: io-uring@vger.kernel.org
>>>
>>> Let me try to remember anything relevant from 5.15,
>>> Thanks for letting know
>>
>> Daniel, following the links I found this:
>>
>> "From: Daniel Black <daniel@mariadb.org>
>> ...
>> The good news is I've validated that the linux mainline 5.14.14 build
>> from https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.14.14/ has
>> actually fixed this problem."
>>
>> To be clear, is the mainline 5.14 kernel affected with the issue?
>> Or does the problem exists only in debian/etc. kernel trees?
> 
> Thanks Pavel for looking.
> 
> I'm retesting https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.14.14/
> in earnest. I did get some assertions, but they may have been
> unrelated. The testing continues...

Thanks for the work on pinpointing it. I'll wait for your conclusion
then, it'll give us an idea what we should look for.


> The problem with debian trees on 5.14.12 (as
> linux-image-5.14.0-3-amd64_5.14.12-1_amd64.deb) was quite real
> https://jira.mariadb.org/browse/MDEV-26674?focusedCommentId=203155&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-203155
> 
> 
> What is concrete is the fc34 package of 5.14.14 (which obviously does
> have a Red Hat delta
> https://src.fedoraproject.org/rpms/kernel/blob/f34/f/patch-5.14-redhat.patch),
> but unsure of significance. Output below:
> 
> https://koji.fedoraproject.org/koji/buildinfo?buildID=1847210
> 
> $ uname -a
> Linux localhost.localdomain 5.14.14-200.fc34.x86_64 #1 SMP Wed Oct 20
> 16:15:12 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
> 
> ~/repos/mariadb-server-10.6 10.6
> $ bd
> 
> ~/repos/build-mariadb-server-10.6
> $ mysql-test/mtr  --parallel=4 encryption.innochecksum{,,,,,}
> Logging: /home/dan/repos/mariadb-server-10.6/mysql-test/mariadb-test-run.pl
>   --parallel=4 encryption.innochecksum encryption.innochecksum
> encryption.innochecksum encryption.innochecksum
> encryption.innochecksum encryption.innochecksum
> vardir: /home/dan/repos/build-mariadb-server-10.6/mysql-test/var
> Removing old var directory...
>   - WARNING: Using the 'mysql-test/var' symlink
> The destination for symlink
> /home/dan/repos/build-mariadb-server-10.6/mysql-test/var does not
> exist; Removing it and creating a new var directory
> Creating var directory
> '/home/dan/repos/build-mariadb-server-10.6/mysql-test/var'...
> Checking supported features...
> MariaDB Version 10.6.5-MariaDB
>   - SSL connections supported
>   - binaries built with wsrep patch
> Collecting tests...
> Installing system database...
> 
> ==============================================================================
> 
> TEST                                  WORKER RESULT   TIME (ms) or COMMENT
> --------------------------------------------------------------------------
> 
> worker[1] Using MTR_BUILD_THREAD 300, with reserved ports 16000..16019
> worker[3] Using MTR_BUILD_THREAD 302, with reserved ports 16040..16059
> worker[2] Using MTR_BUILD_THREAD 301, with reserved ports 16020..16039
> worker[4] Using MTR_BUILD_THREAD 303, with reserved ports 16060..16079
> encryption.innochecksum '16k,cbc,innodb,strict_crc32' w3 [ pass ]   5460
> encryption.innochecksum '16k,cbc,innodb,strict_crc32' w2 [ pass ]   5418
> encryption.innochecksum '16k,cbc,innodb,strict_crc32' w1 [ pass ]   9391
> encryption.innochecksum '16k,cbc,innodb,strict_crc32' w3 [ pass ]   8682
> encryption.innochecksum '16k,cbc,innodb,strict_crc32' w3 [ pass ]   3873
> encryption.innochecksum '8k,cbc,innodb,strict_crc32' w1 [ pass ]   9133
> encryption.innochecksum '4k,cbc,innodb,strict_crc32' w2 [ pass ]  11074
> encryption.innochecksum '8k,cbc,innodb,strict_crc32' w1 [ pass ]   5253
> encryption.innochecksum '16k,cbc,innodb,strict_full_crc32' w3 [ pass ]   4019
> encryption.innochecksum '4k,cbc,innodb,strict_crc32' w2 [ pass ]   6318
> encryption.innochecksum '16k,cbc,innodb,strict_full_crc32' w3 [ pass ]   6176
> encryption.innochecksum '8k,cbc,innodb,strict_crc32' w1 [ pass ]   7305
> encryption.innochecksum '16k,cbc,innodb,strict_full_crc32' w3 [ pass ]   4430
> encryption.innochecksum '4k,cbc,innodb,strict_crc32' w2 [ pass ]  10005
> encryption.innochecksum '8k,cbc,innodb,strict_crc32' w1 [ pass ]   6878
> encryption.innochecksum '16k,cbc,innodb,strict_full_crc32' w3 [ pass ]   3613
> encryption.innochecksum '16k,cbc,innodb,strict_full_crc32' w3 [ pass ]   3875
> encryption.innochecksum '4k,cbc,innodb,strict_crc32' w2 [ pass ]   6612
> encryption.innochecksum '8k,cbc,innodb,strict_crc32' w1 [ pass ]   4901
> encryption.innochecksum '16k,cbc,innodb,strict_full_crc32' w3 [ pass ]   3853
> encryption.innochecksum '8k,cbc,innodb,strict_crc32' w1 [ pass ]   5080
> encryption.innochecksum '4k,cbc,innodb,strict_crc32' w2 [ pass ]   7072
> encryption.innochecksum '4k,cbc,innodb,strict_crc32' w2 [ pass ]   6774
> encryption.innochecksum '4k,cbc,innodb,strict_full_crc32' w3 [ pass ]   7037
> encryption.innochecksum '8k,cbc,innodb,strict_full_crc32' w1 [ pass ]   4961
> encryption.innochecksum '8k,cbc,innodb,strict_full_crc32' w1 [ pass ]   5692
> encryption.innochecksum '4k,cbc,innodb,strict_full_crc32' w3 [ pass ]   8449
> encryption.innochecksum '16k,ctr,innodb,strict_crc32' w2 [ pass ]   5515
> encryption.innochecksum '8k,cbc,innodb,strict_full_crc32' w1 [ pass ]   5650
> encryption.innochecksum '16k,ctr,innodb,strict_crc32' w2 [ pass ]   3722
> encryption.innochecksum '4k,cbc,innodb,strict_full_crc32' w3 [ pass ]   6691
> encryption.innochecksum '8k,cbc,innodb,strict_full_crc32' w1 [ pass ]   4611
> encryption.innochecksum '16k,ctr,innodb,strict_crc32' w2 [ pass ]   4587
> encryption.innochecksum '16k,ctr,innodb,strict_crc32' w2 [ pass ]   5465
> encryption.innochecksum '8k,cbc,innodb,strict_full_crc32' w1 [ pass ]   6900
> encryption.innochecksum '4k,cbc,innodb,strict_full_crc32' w3 [ pass ]   8333
> encryption.innochecksum '16k,ctr,innodb,strict_crc32' w2 [ pass ]   4691
> encryption.innochecksum '8k,cbc,innodb,strict_full_crc32' w1 [ pass ]   5077
> encryption.innochecksum '4k,cbc,innodb,strict_full_crc32' w3 [ pass ]   6319
> encryption.innochecksum '16k,ctr,innodb,strict_crc32' w2 [ pass ]   4590
> encryption.innochecksum '4k,ctr,innodb,strict_crc32' w1 [ pass ]   9683
> encryption.innochecksum '8k,ctr,innodb,strict_crc32' w2 [ pass ]   5404
> encryption.innochecksum '4k,ctr,innodb,strict_crc32' w1 [ pass ]   6775
> encryption.innochecksum '8k,ctr,innodb,strict_crc32' w2 [ pass ]   6190
> encryption.innochecksum '4k,ctr,innodb,strict_crc32' w1 [ pass ]   9354
> encryption.innochecksum '8k,ctr,innodb,strict_crc32' w2 [ pass ]   7734
> encryption.innochecksum '8k,ctr,innodb,strict_crc32' w2 [ pass ]   4993
> encryption.innochecksum '4k,ctr,innodb,strict_crc32' w1 [ pass ]   6280
> encryption.innochecksum '8k,ctr,innodb,strict_crc32' w2 [ pass ]   4487
> encryption.innochecksum '4k,ctr,innodb,strict_crc32' w1 [ pass ]   6971
> encryption.innochecksum '8k,ctr,innodb,strict_crc32' w2 [ pass ]   5172
> encryption.innochecksum '4k,ctr,innodb,strict_crc32' w1 [ pass ]   6317
> encryption.innochecksum '16k,ctr,innodb,strict_full_crc32' w2 [ pass ]   3371
> encryption.innochecksum '16k,ctr,innodb,strict_full_crc32' w2 [ pass ]   3472
> encryption.innochecksum '16k,ctr,innodb,strict_full_crc32' w2 [ pass ]   6707
> encryption.innochecksum '4k,ctr,innodb,strict_full_crc32' w1 [ pass ]   9337
> encryption.innochecksum '16k,ctr,innodb,strict_full_crc32' w2 [ pass ]   9176
> encryption.innochecksum '4k,ctr,innodb,strict_full_crc32' w1 [ pass ]  11817
> encryption.innochecksum '16k,ctr,innodb,strict_full_crc32' w2 [ pass ]   3419
> encryption.innochecksum '16k,ctr,innodb,strict_full_crc32' w2 [ pass ]   5256
> encryption.innochecksum '4k,ctr,innodb,strict_full_crc32' w1 [ pass ]   9291
> encryption.innochecksum '4k,ctr,innodb,strict_full_crc32' w1 [ pass ]   6508
> encryption.innochecksum '4k,ctr,innodb,strict_full_crc32' w2 [ pass ]   6294
> encryption.innochecksum '4k,ctr,innodb,strict_full_crc32' w1 [ pass ]   6327
> encryption.innochecksum '8k,ctr,innodb,strict_full_crc32' w2 [ pass ]   4579
> encryption.innochecksum '8k,ctr,innodb,strict_full_crc32' w1 [ pass ]   4764
> encryption.innochecksum '8k,ctr,innodb,strict_full_crc32' w2 [ pass ]   4469
> encryption.innochecksum '8k,ctr,innodb,strict_full_crc32' w1 [ pass ]   4677
> encryption.innochecksum '8k,ctr,innodb,strict_full_crc32' w2 [ pass ]   4696
> encryption.innochecksum '8k,ctr,innodb,strict_full_crc32' w1 [ pass ]   3898
> encryption.innochecksum '4k,cbc,innodb,strict_full_crc32' w3 [ pass ]  127358
> encryption.innochecksum '16k,cbc,innodb,strict_crc32' w4 [ fail ]
>          Test ended at 2021-10-25 21:39:13
> 
> CURRENT_TEST: encryption.innochecksum
> mysqltest: At line 41: query 'INSERT INTO t3 SELECT * FROM t1' failed:
> <Unknown> (2013): Lost connection to server during query
> 
> The result from queries just before the failure was:
> SET GLOBAL innodb_file_per_table = ON;
> set global innodb_compression_algorithm = 1;
> # Create and populate a tables
> CREATE TABLE t1 (a INT AUTO_INCREMENT PRIMARY KEY, b TEXT)
> ENGINE=InnoDB ENCRYPTED=YES ENCRYPTION_KEY_ID=4;
> CREATE TABLE t2 (a INT AUTO_INCREMENT PRIMARY KEY, b TEXT)
> ENGINE=InnoDB ROW_FORMAT=COMPRESSED ENCRYPTED=YES ENCRYPTION_KEY_ID=4;
> CREATE TABLE t3 (a INT AUTO_INCREMENT PRIMARY KEY, b TEXT)
> ENGINE=InnoDB ROW_FORMAT=COMPRESSED ENCRYPTED=NO;
> CREATE TABLE t4 (a INT AUTO_INCREMENT PRIMARY KEY, b TEXT)
> ENGINE=InnoDB PAGE_COMPRESSED=1;
> CREATE TABLE t5 (a INT AUTO_INCREMENT PRIMARY KEY, b TEXT)
> ENGINE=InnoDB PAGE_COMPRESSED=1 ENCRYPTED=YES ENCRYPTION_KEY_ID=4;
> CREATE TABLE t6 (a INT AUTO_INCREMENT PRIMARY KEY, b TEXT) ENGINE=InnoDB;
> 
> 
> Server [mysqld.1 - pid: 15380, winpid: 15380, exit: 256] failed during test run
> Server log from this test:
> ----------SERVER LOG START-----------
> $ /home/dan/repos/build-mariadb-server-10.6/sql/mariadbd
> --defaults-group-suffix=.1
> --defaults-file=/home/dan/repos/build-mariadb-server-10.6/mysql-test/var/4/my.cnf
> --log-output=file --innodb-page-size=16K
> --skip-innodb-read-only-compressed
> --innodb-checksum-algorithm=strict_crc32 --innodb-flush-sync=OFF
> --innodb --innodb-cmpmem --innodb-cmp-per-index --innodb-trx
> --innodb-locks --innodb-lock-waits --innodb-metrics
> --innodb-buffer-pool-stats --innodb-buffer-page
> --innodb-buffer-page-lru --innodb-sys-columns --innodb-sys-fields
> --innodb-sys-foreign --innodb-sys-foreign-cols --innodb-sys-indexes
> --innodb-sys-tables --innodb-sys-virtual
> --plugin-load-add=file_key_management.so --loose-file-key-management
> --loose-file-key-management-filename=/home/dan/repos/mariadb-server-10.6/mysql-test/std_data/keys.txt
> --file-key-management-encryption-algorithm=aes_cbc
> --skip-innodb-read-only-compressed --core-file
> --loose-debug-sync-timeout=300
> 2021-10-25 21:28:56 0 [Note]
> /home/dan/repos/build-mariadb-server-10.6/sql/mariadbd (server
> 10.6.5-MariaDB-log) starting as process 15381 ...
> 2021-10-25 21:28:56 0 [Warning] Could not increase number of
> max_open_files to more than 1024 (request: 32190)
> 2021-10-25 21:28:56 0 [Warning] Changed limits: max_open_files: 1024
> max_connections: 151 (was 151)  table_cache: 421 (was 2000)
> 2021-10-25 21:28:56 0 [Note] Plugin 'partition' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'SEQUENCE' is disabled.
> 2021-10-25 21:28:56 0 [Note] InnoDB: Compressed tables use zlib 1.2.11
> 2021-10-25 21:28:56 0 [Note] InnoDB: Number of pools: 1
> 2021-10-25 21:28:56 0 [Note] InnoDB: Using crc32 + pclmulqdq instructions
> 2021-10-25 21:28:56 0 [Note] InnoDB: Using liburing
> 2021-10-25 21:28:56 0 [Note] InnoDB: Initializing buffer pool, total
> size = 8388608, chunk size = 8388608
> 2021-10-25 21:28:56 0 [Note] InnoDB: Completed initialization of buffer pool
> 2021-10-25 21:28:56 0 [Note] InnoDB: 128 rollback segments are active.
> 2021-10-25 21:28:56 0 [Note] InnoDB: Creating shared tablespace for
> temporary tables
> 2021-10-25 21:28:56 0 [Note] InnoDB: Setting file './ibtmp1' size to
> 12 MB. Physically writing the file full; Please wait ...
> 2021-10-25 21:28:56 0 [Note] InnoDB: File './ibtmp1' size is now 12 MB.
> 2021-10-25 21:28:56 0 [Note] InnoDB: 10.6.5 started; log sequence
> number 43637; transaction id 17
> 2021-10-25 21:28:56 0 [Note] InnoDB: Loading buffer pool(s) from
> /home/dan/repos/build-mariadb-server-10.6/mysql-test/var/4/mysqld.1/data/ib_buffer_pool
> 2021-10-25 21:28:56 0 [Note] Plugin 'INNODB_FT_CONFIG' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'INNODB_SYS_TABLESTATS' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'INNODB_FT_DELETED' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'INNODB_CMP' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'THREAD_POOL_WAITS' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'INNODB_CMP_RESET' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'THREAD_POOL_QUEUES' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'FEEDBACK' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'INNODB_FT_INDEX_TABLE' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'THREAD_POOL_GROUPS' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'INNODB_CMP_PER_INDEX_RESET' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'INNODB_FT_INDEX_CACHE' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'INNODB_FT_BEING_DELETED' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'INNODB_CMPMEM_RESET' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'INNODB_FT_DEFAULT_STOPWORD' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'INNODB_SYS_TABLESPACES' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'user_variables' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'INNODB_TABLESPACES_ENCRYPTION' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'THREAD_POOL_STATS' is disabled.
> 2021-10-25 21:28:56 0 [Note] Plugin 'unix_socket' is disabled.
> 2021-10-25 21:28:56 0 [Warning]
> /home/dan/repos/build-mariadb-server-10.6/sql/mariadbd: unknown
> variable 'loose-feedback-debug-startup-interval=20'
> 2021-10-25 21:28:56 0 [Warning]
> /home/dan/repos/build-mariadb-server-10.6/sql/mariadbd: unknown
> variable 'loose-feedback-debug-first-interval=60'
> 2021-10-25 21:28:56 0 [Warning]
> /home/dan/repos/build-mariadb-server-10.6/sql/mariadbd: unknown
> variable 'loose-feedback-debug-interval=60'
> 2021-10-25 21:28:56 0 [Warning]
> /home/dan/repos/build-mariadb-server-10.6/sql/mariadbd: unknown option
> '--loose-pam-debug'
> 2021-10-25 21:28:56 0 [Warning]
> /home/dan/repos/build-mariadb-server-10.6/sql/mariadbd: unknown option
> '--loose-aria'
> 2021-10-25 21:28:56 0 [Warning]
> /home/dan/repos/build-mariadb-server-10.6/sql/mariadbd: unknown
> variable 'loose-debug-sync-timeout=300'
> 2021-10-25 21:28:56 0 [Note] Server socket created on IP: '127.0.0.1'.
> 2021-10-25 21:28:56 0 [Note]
> /home/dan/repos/build-mariadb-server-10.6/sql/mariadbd: ready for
> connections.
> Version: '10.6.5-MariaDB-log'  socket:
> '/home/dan/repos/build-mariadb-server-10.6/mysql-test/var/tmp/4/mysqld.1.sock'
>   port: 16060  Source distribution
> 2021-10-25 21:28:56 0 [Note] InnoDB: Buffer pool(s) load completed at
> 211025 21:28:56
> 2021-10-25 21:39:11 0 [ERROR] [FATAL] InnoDB:
> innodb_fatal_semaphore_wait_threshold was exceeded for dict_sys.latch
> 

-- 
Pavel Begunkov
