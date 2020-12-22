Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD452E0494
	for <lists+io-uring@lfdr.de>; Tue, 22 Dec 2020 04:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgLVDEB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Dec 2020 22:04:01 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:56121 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725869AbgLVDEB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Dec 2020 22:04:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UJP3jDe_1608606197;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UJP3jDe_1608606197)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 22 Dec 2020 11:03:17 +0800
Subject: Re: [PATCH liburing] test: use a map to define test files / devices
 we need
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1607430489-10020-1-git-send-email-haoxu@linux.alibaba.com>
 <12018281-f8d4-7a67-3ffc-49d6a1c721b8@linux.alibaba.com>
Message-ID: <87b3001f-0984-3890-269b-1a069704e374@linux.alibaba.com>
Date:   Tue, 22 Dec 2020 11:03:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <12018281-f8d4-7a67-3ffc-49d6a1c721b8@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2020/12/15 上午10:44, Hao Xu 写道:
> 在 2020/12/8 下午8:28, Hao Xu 写道:
> ping...
Hi Jens,
I'm currently develop a test which need a device arg, so I
leverage TEST_FILES, I found it may be better to form
TEST_FILES as a key-value structure.
Thanks && Regards,
Hao
>> Different tests need different files / devices, use a map to indicate
>> what each test need.
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>
>> the former implementation use a array for the global list TEST_FILES,
>> which may causes this:
>>     TEST_FILES="dev0 dev1"
>>     dev0 required by test0
>>     dev1 required by test1
>> In the <for tst in $TESTS> loop, we run the test for each $dev, which
>> makes <test0 dev1> and <test1 dev0> run, these are not expected.
>> Currently I see that statx.c accept argv[1] as a file_name, if someone
>> writes another test which defines a device(say nvme0n1) in TEST_FILES,
>> it may cause issues.
>>
>>   test/config      |  2 +-
>>   test/runtests.sh | 13 ++++++-------
>>   2 files changed, 7 insertions(+), 8 deletions(-)
>>
>> diff --git a/test/config b/test/config
>> index cab270359155..1bd9b40207bb 100644
>> --- a/test/config
>> +++ b/test/config
>> @@ -4,4 +4,4 @@
>>   # TEST_EXCLUDE=""
>>   #
>>   # Define raw test devices (or files) for test cases, if any
>> -# TEST_FILES="/dev/nvme0n1p2 /data/file"
>> +# declare -A TEST_FILES=()
>> diff --git a/test/runtests.sh b/test/runtests.sh
>> index fa240f205542..1a6905b42768 100755
>> --- a/test/runtests.sh
>> +++ b/test/runtests.sh
>> @@ -5,10 +5,10 @@ RET=0
>>   TIMEOUT=60
>>   DMESG_FILTER="cat"
>>   TEST_DIR=$(dirname $0)
>> -TEST_FILES=""
>>   FAILED=""
>>   SKIPPED=""
>>   MAYBE_FAILED=""
>> +declare -A TEST_FILES
>>   # Only use /dev/kmsg if running as root
>>   DO_KMSG="1"
>> @@ -17,7 +17,7 @@ DO_KMSG="1"
>>   # Include config.local if exists and check TEST_FILES for valid devices
>>   if [ -f "$TEST_DIR/config.local" ]; then
>>       . $TEST_DIR/config.local
>> -    for dev in $TEST_FILES; do
>> +    for dev in ${TEST_FILES[@]}; do
>>           if [ ! -e "$dev" ]; then
>>               echo "Test file $dev not valid"
>>               exit 1
>> @@ -109,11 +109,10 @@ run_test()
>>   # Run all specified tests
>>   for tst in $TESTS; do
>> -    run_test $tst
>> -    if [ ! -z "$TEST_FILES" ]; then
>> -        for dev in $TEST_FILES; do
>> -            run_test $tst $dev
>> -        done
>> +    if [ ! -n "${TEST_FILES[$tst]}" ]; then
>> +        run_test $tst
>> +    else
>> +        run_test $tst ${TEST_FILES[$tst]}
>>       fi
>>   done
>>

