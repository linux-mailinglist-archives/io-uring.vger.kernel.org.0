Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EB7435D14
	for <lists+io-uring@lfdr.de>; Thu, 21 Oct 2021 10:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhJUImk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Oct 2021 04:42:40 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:43507 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231510AbhJUImj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Oct 2021 04:42:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Ut824Ep_1634805621;
Received: from legedeMacBook-Pro.local(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Ut824Ep_1634805621)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 21 Oct 2021 16:40:22 +0800
Subject: Re: [RFC 1/1] io_uring: improve register file feature's usability
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <20211012084811.29714-1-xiaoguang.wang@linux.alibaba.com>
 <20211012084811.29714-2-xiaoguang.wang@linux.alibaba.com>
 <7899b071-16cf-154d-3354-2211309c2949@gmail.com>
 <b08c5add-96cd-9b1a-0ac5-32a62cace9a4@linux.alibaba.com>
 <4211b3d1-42a8-4528-2c72-7fddf3bddcf6@gmail.com>
 <98943ac6-772c-fd18-8d47-fbd16de10894@linux.alibaba.com>
 <bd7431f2-106c-ab75-fafd-7f36df4e2c8f@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <e4ed60a6-123a-5f08-5e73-7dbb27d6e9dc@linux.alibaba.com>
Date:   Thu, 21 Oct 2021 16:40:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <bd7431f2-106c-ab75-fafd-7f36df4e2c8f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,


> On 10/13/21 04:32, Xiaoguang Wang wrote:
>> hi,
>>> On 10/12/21 14:11, Xiaoguang Wang wrote:
>>>>> On 10/12/21 09:48, Xiaoguang Wang wrote:
>>>>>> The idea behind register file feature is good and 
>>>>>> straightforward, but
>>>>>> there is a very big issue that it's hard to use for user apps. 
>>>>>> User apps
>>>>>> need to bind slot info to file descriptor. For example, user app 
>>>>>> wants
>>>>>> to register a file, then it first needs to find a free slot in 
>>>>>> register
>>>>>> file infrastructure, that means user app needs to maintain slot 
>>>>>> info in
>>>>>> userspace, which is a obvious burden for userspace developers.
>>>>>
>>>>> Slot allocation is specifically entirely given away to the userspace,
>>>>> the userspace has more info and can use it more efficiently, e.g.
>>>>> if there is only a small managed set of registered files they can
>>>>> always have O(1) slot "lookup", and a couple of more use cases.
>>>>
>>>> Can you explain more what is slot "lookup", thanks. For me, it 
>>>> seems that
>>>
>>> I referred to nothing particular, just a way userspace finds a new 
>>> index,
>>> can be round robin or "index==fd".
>>>
>>>> use fd as slot is the simplest and most efficient way, user does 
>>>> not need to> mange slot info at all in userspace.
>>>
>>> As mentioned, it should be slightly more efficient to have a small 
>>> table,
>>> cache misses. Also, it's allocated with kvcalloc() so if it can't be
>>> allocate physically contig memory it will set up virtual memory.
>>>
>>> So, if the userspace has some other way of indexing files, small tables
>>> are preferred. For instance if it operates with 1-2 files, or stores 
>>> files
>>> in an array and the index in the array may serve the purpose, or any 
>>> other
>>> way. Also, additional memory for those who care.
>>
>> Yeah, I agree with you that for small tables, current implementation 
>> seems good,
>>
>> If user app just registers a small number of files, it may handle it 
>> well, but imagine
>>
>> how netty, nginx or other network apps which will open thousands of 
>> socket files,
>>
>> manage these socket files' slot info will be a obvious burden to 
>> developer, these
>>
>> apps may need to develop a private component to record used or free 
>> slot. Especially
>>
>> in a high concurrency scenario, frequent sockes opened or closed, 
>> this private component
>>
>> may need locks to protect, that means this private component will 
>> introduce overhead too.
>>
>> For a fd, vfs layer has already ensure its unique.
>>
>>>
>>>>> If userspace wants to mimic a fdtable into io_uring's registered 
>>>>> table,
>>>>> it's possible to do as is and without extra fdtable tracking
>>>>>
>>>>> fd = open();
>>>>> io_uring_update_slot(off=fd, fd=fd);
>>>>
>>>> No, currently it's hard to do above work, unless we register a big 
>>>> number of files initially.
>>>
>>> If they intend to use a big number of files that's the way to go. They
>>> can unregister/register if needed, usual grow factor=2  should make
>>> it workable.
>>
>> I'm not sure un-register/register are appropriate，say a app registers 
>> 1000 files, then
>>
>> it needs to un-register 1000 files firstly, there are doubts whether 
>> can do this un-registration
>>
>> work, if some of these files are used by other threads, which submit 
>> sqes with FIXED_FILE
>>
>> flags continually, so the first un-registration work needs to 
>> synchronize with threads which
>>
>> are submitting requests. And later app needs to prepare a new files 
>> array, saving current 1000
>>
>> files and new files info to this new array, for me, it can works, but 
>> not efficient and somewhat
>>
>> hard to use :)
>
> Sounds reasonable. What I oppose is wiring it solely based on fd. On the

Are the main concerns are that you worry about the possible big memory 
consumption, which

also may not be allocated physically continuous?  If user app open 
thousands of files, but only

make a small set of files registered, this method is really not good.


What about adding a new flag, like IORING_SETUP_REGISTER_FILES_BY_FD. If 
user creates

a uring instance with this flag, we'll support register files by fd. App 
that make most of its opened

files registered will benefit from this feature, not to maintain slot 
offset info anymore.


Considering the future, once io_uring becomes the main program 
interface, every file maybe

opened by io_uring, so we can register every file opened by io_uring, 
after all, file registration

feature gives performance improvements. In this scenario, this new 
registration method seems

simplest.


> other hand, it sounds what you need is a "grow table" feature.

No, it's just a result. What I want is that we can use fd as slot info 
to register files. Once a new fd

is returned by open(2), it means the slot indexed by this fd in io_uring 
io_file_table can be updated

safely, which is convenient for user app. "grow table" feature is just 
used to implement this support.


>
> We can also think about adding new format, instead of array of fds, add
> passing an array of pairs {offset, fd}.

Can you explain more about this format, or does this will simply user 
apps' slot info maintain burden?


Regards,

Xiaoguang Wang

