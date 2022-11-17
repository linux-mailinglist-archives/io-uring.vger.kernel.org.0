Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B031A62E672
	for <lists+io-uring@lfdr.de>; Thu, 17 Nov 2022 22:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240267AbiKQVJs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Thu, 17 Nov 2022 16:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240372AbiKQVJ1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Nov 2022 16:09:27 -0500
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Nov 2022 13:08:11 PST
Received: from smtp2.emailarray.com (smtp.emailarray.com [69.28.212.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6E58430A
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 13:08:11 -0800 (PST)
Received: (qmail 71867 invoked by uid 89); 17 Nov 2022 21:01:30 -0000
Received: from unknown (HELO ?192.168.137.22?) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzMS44MA==) (POLARISLOCAL)  
  by smtp2.emailarray.com with ESMTPS (AES256-GCM-SHA384 encrypted); 17 Nov 2022 21:01:30 -0000
From:   Jonathan Lemon <jlemon@flugsvamp.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH v1 06/15] io_uring: Provide driver API for zctap packet
 buffers.
Date:   Thu, 17 Nov 2022 13:01:28 -0800
X-Mailer: MailMate (1.14r5918)
Message-ID: <79C18852-F1B8-4292-99F9-25545236D1E6@flugsvamp.com>
In-Reply-To: <Y3ScjuwlCPSrnwZV@infradead.org>
References: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
 <20221108050521.3198458-7-jonathan.lemon@gmail.com>
 <Y3ScjuwlCPSrnwZV@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 16 Nov 2022, at 0:17, Christoph Hellwig wrote:

> On Mon, Nov 07, 2022 at 09:05:12PM -0800, Jonathan Lemon wrote:
>> +struct io_zctap_buf *io_zctap_get_buf(struct io_zctap_ifq *ifq, int refc)
>> +{
>> +	return NULL;
>> +}
>> +EXPORT_SYMBOL(io_zctap_get_buf);
>> +
>> +void io_zctap_put_buf(struct io_zctap_ifq *ifq, struct io_zctap_buf *buf)
>> +{
>> +}
>> +EXPORT_SYMBOL(io_zctap_put_buf);
>
> Adding stubs without anything in them is rather pointless.

This patch just introduces the API, for easier reviewing (and handling
some patch dependencies).  Patch 8 adds the initial implementation.


> Also why are these exported?  I can't find any modular users anywhere.
> Even if so, any low-level uring zero copy functionality should be
> EXPORT_SYMBOL_GPL, and only added once the modular users show up and
> are discussed.

I just copied EXPORT_SYMBOL from io_uring.c, and have no preference
as to which export variant is used.

I was testing against several drivers, which were loadable modules for
ease of development.  For example, Broadcom’s in-tree bnxt driver does not
(currently) have steering support, so testing was against their external
driver package while waiting for the features to land upstream.
-- 
Jonathan
