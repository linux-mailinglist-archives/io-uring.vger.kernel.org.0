Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC882DE8BE
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 19:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgLRSHG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 13:07:06 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39780 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgLRSHG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 13:07:06 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII3wJo124623;
        Fri, 18 Dec 2020 18:06:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Gm4RWMh9rzpZURntZt2KWq8+fMt+vANU/tQUH9Q9AgE=;
 b=dUBAlpy5btKsg2/olWJ5+j4dkfMxNbbdOM22dMl0Q3Tmt7sDA+emWrAMA+0JFv5+9pZ7
 eJIudfTwvNj3l0eSBqxUR49QCTzXUNDFIarI106imtxQ2B4cx3b781OAeKf8pRGoDVu0
 Qq5yKi1XY8bjSQlRoXnQJ93c3PVJXrP0xia7sk1RS9rmLhtKvAdm3YGLbp8v70pGIQ4q
 H0KBKH/QcqeghcoVZncqic0wH6Rd1J08RirRZUVzppl/UU+IKJzMrAkpeGMCjXUI/AEE
 PMjZ7JkY5FXXXT3vTUdB1VgS0aFkj1JsQc9WhRV5W7zFdxrR3Bnu4n0hoyTFs6wsDPHN kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35ckcbuq39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Dec 2020 18:06:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII5N5P117134;
        Fri, 18 Dec 2020 18:06:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35g3rgf9u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 18:06:22 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BII6Lw9015942;
        Fri, 18 Dec 2020 18:06:21 GMT
Received: from [10.154.184.112] (/10.154.184.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Dec 2020 10:06:21 -0800
Subject: Re: [PATCH v2 08/13] io_uring: implement fixed buffers registration
 similar to fixed files
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1607379352-68109-9-git-send-email-bijan.mottahedeh@oracle.com>
 <d9b4abb9-61e2-4751-9350-99fc58b02aae@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <b0af8ca3-4506-1f89-6f39-854d982d1abd@oracle.com>
Date:   Fri, 18 Dec 2020 10:06:19 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <d9b4abb9-61e2-4751-9350-99fc58b02aae@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 201217-2, 12/17/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180124
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


>> -static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
>> +static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
> 
> I think this and some others from here can go into a separate patch, would
> be cleaner.
> 

I tried to break this up a few ways but it didn't work well because I 
think most of the code changes depend on the io_uring structure changes.
I've left it as is for now but if you have some idea on what you want to 
do, we can do it next.

