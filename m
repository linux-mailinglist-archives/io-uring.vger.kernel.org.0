Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078392DA0C4
	for <lists+io-uring@lfdr.de>; Mon, 14 Dec 2020 20:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731027AbgLNTqR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 14:46:17 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39014 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729523AbgLNTqQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 14:46:16 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEJhliW070525;
        Mon, 14 Dec 2020 19:45:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zapXKM0TaBgpCIEkurfYkARt8YhirwQKqDxYd9xl6AM=;
 b=Xf7fUv9lqasGEbJkdV/Ke3Yc4hDZJi+7zAmU/NoZYj0qiA+VaoqP9h9WhRKS/OJr5rL7
 DgeE1kpuyrNjRNkX9jomdf6D4SDs2uajU+M9sOi5Yq/8EmuI1+U5jD3VE6WUWCstD6xj
 USDCcTkrk2dNGDXFtA0HQjQpv4ipPE6PlxCFS55SqGjDSzlPbfntItIZFLwx7U5IjFCT
 6dSkgRjXtvE0MiZ7zfnaotoNQ7Ej9qtpR3+Wgf0IiHKtbHryeK64Llum3rudIsJrD9+7
 XdER4MnCRU+7bEsoNMbBWixiuzhQn53GHkm9kEnkqs3yRVaCinS3WJpKXf9IIJaxx3Zn IQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35ckcb7afe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 19:45:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEJf9RN121232;
        Mon, 14 Dec 2020 19:43:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35d7ekx69h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 19:43:33 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BEJhXHw019198;
        Mon, 14 Dec 2020 19:43:33 GMT
Received: from [10.154.105.161] (/10.154.105.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 11:43:33 -0800
Subject: Re: [PATCH v2 00/13] io_uring: buffer registration enhancements
To:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        io-uring@vger.kernel.org
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
 <e8afcd4c-37b8-f02e-c648-4cd14f12636a@oracle.com>
 <b9379af3-c7cc-03ca-8510-7803b54ae7e9@kernel.dk>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <727da608-b8fe-546e-0691-800cae8a8bd0@oracle.com>
Date:   Mon, 14 Dec 2020 11:43:31 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <b9379af3-c7cc-03ca-8510-7803b54ae7e9@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 201006-2, 10/06/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140131
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/14/2020 11:29 AM, Jens Axboe wrote:
> On 12/14/20 12:09 PM, Bijan Mottahedeh wrote:
>> Just a ping.  Anything I can do to facilitate the review, please let me
>> know.
> 
> I'll get to this soon - sorry that this means that it'll miss 5.11, but
> I wanted to make sure that we get this absolutely right. It is
> definitely an interesting and useful feature, but worth spending the
> necessary time on to ensure we don't have any mistakes we'll regret
> later.

Makes total sense.

> 
> For your question, yes I think we could add sqe->update_flags (something
> like that) and union it with the other flags, and add a flag that means
> we're updating buffers instead of files. A bit iffy with the naming of
> the opcode itself, but probably still a useful way to go.

I'll look into that and we can fold it in the next round, would that work?

> 
> I'd also love to see a bunch of test cases for this that exercise all
> parts of it.
> 

Great idea.  Should I send out the liburing changes and test cases now, 
that would definitely help identify the gaps early.

Thanks.

--bijan


