Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961091DA4FF
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 00:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgESWu1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 May 2020 18:50:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39102 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgESWu0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 May 2020 18:50:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JMmFu9114932;
        Tue, 19 May 2020 22:50:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PETvSFCO3YDbddASlUfJZ1c0tt7Sk9Wy16TgnjPfUU4=;
 b=d03e2tYU7qTy03swPM1i1cgYz70TWwLNSRZ/uAH4wYPBb4b279D9Vc7+qMoSvOajrsNw
 a+Vxvc3UomdGbEj0GfZtcdp4rE4hMdJ8RhiR1jE5IaIMIXlB+C3782TNHZXn3wygFrC9
 jsYhrhq8jClroUS5PHU5aNCwJXR9vvdWwJy4ix+sIFC2Zj7Qz+NjyPj3f3KCiGl8/OWv
 swG3dn6tjoivrLfjHR8gwqwGTkITYSSpQ6IZAb3glUazxEyTwM+xKLxpRzsqeNvk3kQL
 flnHiKL0S1sDz1ltkuPefGBfWU/RKmDEcQFRY0rtX0P3tO+JC2vmXid4t9iLxNOQGSUN Lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31284m05fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 22:50:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JMh7wT143819;
        Tue, 19 May 2020 22:48:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 312sxtnt5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 22:48:24 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04JMmNL8025271;
        Tue, 19 May 2020 22:48:23 GMT
Received: from [10.154.115.221] (/10.154.115.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 15:48:23 -0700
Subject: Re: [RFC 1/2] io_uring: don't use kiocb.private to store buf_index
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <1589925170-48687-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1589925170-48687-2-git-send-email-bijan.mottahedeh@oracle.com>
 <6ce9f56d-d4eb-0db1-6ea3-166aed29807f@kernel.dk>
 <91cd9cdb-b65a-879c-0318-a888d2658bed@kernel.dk>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <9a4f1985-c9a2-dc26-7dc4-0443f0a862b5@oracle.com>
Date:   Tue, 19 May 2020 15:48:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <91cd9cdb-b65a-879c-0318-a888d2658bed@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200518-0, 05/17/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190192
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005190193
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/19/2020 3:20 PM, Jens Axboe wrote:
> On 5/19/20 4:07 PM, Jens Axboe wrote:
>> On 5/19/20 3:52 PM, Bijan Mottahedeh wrote:
>>> kiocb.private is used in iomap_dio_rw() so store buf_index separately.
>> Hmm, that's no good, the owner of the iocb really should own ->private
>> as well.
>>
>> The downside of this patch is that io_rw now spills into the next
>> cacheline, which propagates to io_kiocb as well. iocb has 4 bytes
>> of padding, but probably cleaner if we can stuff it into io_kiocb
>> instead. How about adding a u16 after opcode? There's a 2 byte
>> hole there, so it would not impact the size of io_kiocb.
> I applied your patch, but moved the buf_index to not grow the
> structure:
>
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.7&id=4f4eeba87cc731b200bff9372d14a80f5996b277
>

That works.

Thanks!

--bijan
