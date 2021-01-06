Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B222EC423
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 20:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbhAFTrd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 14:47:33 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:37216 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbhAFTrd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 14:47:33 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106JjQZl117515;
        Wed, 6 Jan 2021 19:46:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=IQK8bcAvGYflVyUeraT2XAHcoon/lXrogZfGSGOnRYg=;
 b=RzhPKF+mnjljLovOliF73zPXX9A0o4DeRzsCDAoLvP6yluIZnfTkRh6g9cIWECsoVWpX
 mx9CzKsUmlFipKOrjbsu45p28Q2TtPez7nEMFJ6KTLH5C+inS16JG2QheW7W9+/VIgJ2
 WVzQoDtilukH7hzf173vQQmgi/pM1yBi9L0YSeXULdxicJlpBpzXL5ZXaeUIE88JWStP
 21xiYViorHWanC+Wa/ub7bnGbQ9MPTarMSnRk2JKqGNAt7cGrSd4WXc01iKBoqI0fk6G
 yHEbbPKlJfZl62XEuJhNhtAZ46fXuPWKeyqd48c9jIH369C4H3u8/67yG7+IgUKz2kPI KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35wcuxsxr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 19:46:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106JjQBA021013;
        Wed, 6 Jan 2021 19:46:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 35w3g1gr49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 19:46:50 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 106Jknxb023989;
        Wed, 6 Jan 2021 19:46:49 GMT
Received: from [10.154.148.218] (/10.154.148.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 11:46:49 -0800
Subject: Re: [PATCH v3 08/13] io_uring: implement fixed buffers registration
 similar to fixed files
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1608314848-67329-9-git-send-email-bijan.mottahedeh@oracle.com>
 <f0bff3b0-f27e-80fe-9a58-dfeb347a7e61@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <c982a4ea-e39f-d8e0-1fc7-27086395ea9a@oracle.com>
Date:   Wed, 6 Jan 2021 11:46:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <f0bff3b0-f27e-80fe-9a58-dfeb347a7e61@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 210101-4, 01/01/2021), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060111
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/4/2021 6:43 PM, Pavel Begunkov wrote:
> On 18/12/2020 18:07, Bijan Mottahedeh wrote:
>> Apply fixed_rsrc functionality for fixed buffers support.
> 
> git generated a pretty messy diff...

I had tried to break this up a few ways but it didn't work well because 
I think most of the code changes depend on the io_uring structure 
changes.  I can look again or if you some idea of how you want to split 
it, I can do that.

> Because it's do quiesce, fixed read/write access buffers from asynchronous
> contexts without synchronisation. That won't work anymore, so
> 
> 1. either we save it in advance, that would require extra req_async
> allocation for linked fixed rw
> 
> 2. or synchronise whenever async. But that would mean that a request
> may get and do IO on two different buffers, that's rotten.
> 
> 3. do mixed -- lazy, but if do IO then alloc.
> 
> 3.5 also "synchronise" there would mean uring_lock, that's not welcome,
> but we can probably do rcu.

Are you referring to a case where a fixed buffer request can be 
submitted from async context while those buffers are being unregistered, 
or something like that?

> Let me think of a patch...

Ok, will wait for it.

>> @@ -8373,7 +8433,13 @@ static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
>>   
>>   	/* check previously registered pages */
>>   	for (i = 0; i < ctx->nr_user_bufs; i++) {
>> -		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
>> +		struct fixed_rsrc_table *table;
>> +		struct io_mapped_ubuf *imu;
>> +		unsigned int index;
>> +
>> +		table = &ctx->buf_data->table[i >> IORING_BUF_TABLE_SHIFT];
>> +		index = i & IORING_BUF_TABLE_MASK;
>> +		imu = &table->bufs[index];
> 
> io_buf_from_index() may tak buf_data, so can be reused.

Ok.

>> +	for (i = 0; i < nr_tables; i++) {
>> +		struct fixed_rsrc_table *table = &buf_data->table[i];
>> +		unsigned int this_bufs;
>> +
>> +		this_bufs = min(nr_bufs, IORING_MAX_BUFS_TABLE);
>> +		table->bufs = kcalloc(this_bufs, sizeof(struct io_mapped_ubuf),
>> +				      GFP_KERNEL);
>> +		if (!table->bufs)
>> +			break;
>> +		nr_bufs -= this_bufs;
>> +	}
>> +
>> +	if (i == nr_tables)
>> +		return 0;
>> +
>> +	io_free_buf_tables(buf_data, nr_tables);
> 
> Would work because kcalloc() zeroed buf_data->table, but
> 
> io_free_buf_tables(buf_data, __i__);

Ok.

>>   		ret = io_buffer_validate(&iov);
>>   		if (ret)
>>   			break;
>>   
>> +		table = &buf_data->table[i >> IORING_BUF_TABLE_SHIFT];
> 
> same, io_buf_from_index() can be reused
> 
>> +		index = i & IORING_BUF_TABLE_MASK;
>> +		imu = &table->bufs[index];

Ok.

>> @@ -9854,6 +10023,7 @@ static bool io_register_op_must_quiesce(int op)
>>   	switch (op) {
>>   	case IORING_UNREGISTER_FILES:
>>   	case IORING_REGISTER_FILES_UPDATE:
>> +	case IORING_UNREGISTER_BUFFERS:
> 
> what about REGISTER_BUFFERS?

I followed the FILES case, which deals with UNREGISTER and UPDATE only, 
should I add REGISTER for buffers only?
