Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E2A538D53
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 11:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243000AbiEaJAb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 05:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbiEaJAb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 05:00:31 -0400
Received: from pv50p00im-ztbu10011701.me.com (pv50p00im-ztbu10011701.me.com [17.58.6.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78ED813D1F
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 02:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1653987629;
        bh=YoMvvnFy7lQ2o505i+lUJxUjQt62DbIV+yUB4JeZdsc=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=bBHViiyom6RSqB/K6YUJJxjhK6SjoNMIFuT2eiX8vlslzbYyJlBvPfU7F5ViA7G0q
         dBaS1rZCHnpJarDyhRz1rTVairsrbCGLwyTH31KAtCBsEqMgztT1AaEGgDxqcgsdXJ
         Dsb+J2Qr4weejmgrCpXlWUJwyOtMjn9LIv6gr3DmlNlt09/9w4wZdtaV84tToWduWI
         1utb1blDWhy6qm8exMQMBXCAA5aXKG8FAhUulpcevlAqJGl/IwtLCsfAG58A7I5S3y
         iXgCUGk5AExJgJly246AZywIp/+16GGblpcOC3yNPeYBDrngasFzZXMvClw+6wwiI4
         LmfDyPqCmAhxA==
Received: from [10.97.63.88] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztbu10011701.me.com (Postfix) with ESMTPSA id 19CEBB40348;
        Tue, 31 May 2022 09:00:26 +0000 (UTC)
Message-ID: <e0867860-12c6-e958-07de-cfbcf644b9fe@icloud.com>
Date:   Tue, 31 May 2022 17:00:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [syzbot] UBSAN: array-index-out-of-bounds in io_submit_sqes
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+b6c9b65b6753d333d833@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000f0b26205e04a183b@google.com>
 <3d3c6b5f-84cd-cb25-812e-dac77e02ddbf@kernel.dk>
From:   Hao Xu <haoxu.linux@icloud.com>
In-Reply-To: <3d3c6b5f-84cd-cb25-812e-dac77e02ddbf@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-05-31_03:2022-05-30,2022-05-31 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205310047
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/31/22 16:45, Jens Axboe wrote:
> On 5/31/22 1:55 AM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    3b46e4e44180 Add linux-next specific files for 20220531
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=16e151f5f00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=ccb8d66fc9489ef
>> dashboard link: https://syzkaller.appspot.com/bug?extid=b6c9b65b6753d333d833
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+b6c9b65b6753d333d833@syzkaller.appspotmail.com
>>
>> ================================================================================
>> ================================================================================
>> UBSAN: array-index-out-of-bounds in fs/io_uring.c:8860:19
>> index 75 is out of range for type 'io_op_def [47]'
> 
> 'def' is just set here, it's not actually used after 'opcode' has been
> verified.
> 

Maybe we can move it to be below the opcode check to comfort UBSAN.

