Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28DC343C11
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 09:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhCVIum (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Mar 2021 04:50:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35660 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhCVIu1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Mar 2021 04:50:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12M8nHfh071880;
        Mon, 22 Mar 2021 08:50:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=/geWu0w7Le8GYqmRqAk7HsRLuUJpq3frhQXIIu8mr3Q=;
 b=K9hLevw+U94J7BySdr9I1uwjo7w6DS4JnEJQN3IROQdqGr6g7AWGGBaHK42J9cnylqIR
 G75Z4tha24FYHL+JAnfI94gOOLZ4XZCtBRBmZP7ijNnUEhN1Wzc7c+ou7eQgA47lbmsA
 fDf3G5SzueiKHvGad4LzV7RZNukta245Y6PfE0LOYy5rvpYMD219soq+tJxEA7gsUMM1
 X/GlKgT7XAyi3Wm7Oniulo56pH28ksmz1pAFc3W6oaGL1ZBSDmDtetw3etfvCw/BAMLC
 f5466mhzZOHIO+v9iBI1IYGl3RtGCL7h2b5lli9enJmleMuXOXvP6S702raOpfx1tZjS 0Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37d90mat2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 08:50:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12M8o7Ec052834;
        Mon, 22 Mar 2021 08:50:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 37dttqajmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 08:50:23 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 12M8oMmP018218;
        Mon, 22 Mar 2021 08:50:22 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 22 Mar 2021 01:50:21 -0700
Date:   Mon, 22 Mar 2021 11:50:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [bug report] io_uring: add multishot mode for IORING_OP_POLL_ADD
Message-ID: <YFhaR/TugDDtajCb@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9930 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220069
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9930 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1011 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220069
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Jens Axboe,

This is a semi-automatic email about new static checker warnings.

The patch e7bf437da251: "io_uring: add multishot mode for
IORING_OP_POLL_ADD" from Feb 22, 2021, leads to the following Smatch
complaint:

    fs/io_uring.c:5009 io_poll_double_wake()
    warn: variable dereferenced before check 'poll' (see line 5004)

fs/io_uring.c
  5003			return 0;
  5004		if (!(poll->events & EPOLLONESHOT))
                      ^^^^^^^^^^^^
Dereference

  5005			return poll->wait.func(&poll->wait, mode, sync, key);
  5006	
  5007		list_del_init(&wait->entry);
  5008	
  5009		if (poll && poll->head) {
                    ^^^^
Checked too late.

  5010			bool done;
  5011	

regards,
dan carpenter
