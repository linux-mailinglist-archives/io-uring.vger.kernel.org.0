Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7247355CAE1
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 14:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238288AbiF0Tew (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jun 2022 15:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238279AbiF0Teu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jun 2022 15:34:50 -0400
Received: from smtp.first-world.info (481.saas.confiared.com [IPv6:2803:1920::4:1001])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3033C62F2
        for <io-uring@vger.kernel.org>; Mon, 27 Jun 2022 12:34:49 -0700 (PDT)
Received: from [IPV6:2803:1920::2:10] (unknown [IPv6:2803:1920::2:10])
        by smtp.first-world.info (Postfix) with ESMTPA id C99A4103202
        for <io-uring@vger.kernel.org>; Mon, 27 Jun 2022 19:34:47 +0000 (UTC)
Message-ID: <c9bad71a-e3e4-c746-fc85-0bf296f9b161@first-world.info>
Date:   Mon, 27 Jun 2022 15:34:45 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     io-uring@vger.kernel.org
From:   alpha_one_x86 <alpha_one_x86@first-world.info>
Subject: Need freelance to implement io_uring into CDN
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I do 4000 lignes code CDN, I use sync API open()/read()/write()/close() 
for file.

Code: https://github.com/Confiared/fastcgicdnhttp11

Your target is convert all the IO (file, unix socket, tcp socket, udp 
socker for dns) to io_uring in async mode.

I wait your price as freelance. All the project is published as open 
source and can be a good study case for io_uring.

Cheers,
