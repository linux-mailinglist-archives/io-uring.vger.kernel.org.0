Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090C05FEDE2
	for <lists+io-uring@lfdr.de>; Fri, 14 Oct 2022 14:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiJNMOx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Oct 2022 08:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiJNMOx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Oct 2022 08:14:53 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE4127DCC
        for <io-uring@vger.kernel.org>; Fri, 14 Oct 2022 05:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=To:From:Date:Message-ID:CC;
        bh=ODQZcOJB+MysSVeoPcgDp+BDVH+ctdhT+RJbvZY/QBA=; b=DAM+oFfNSIPT4tflorxj44wrMG
        4S+eWLd9EeP9B2jSJR87h/ZgGZgZ3DNf8E2pw72WbxPomwHDCiVTkHVXKogWQ+ZrEmlvu83gCGzVp
        ZWdK55b3YzXXYVOe3Tc79gnGisPjajptnijEWrEmbOGRdGbppqxbxaBiCiRb/hj4+npAue8pHbzq9
        ECCACgEmdEtQ9qXa/suTjVXZGa+4dg7W6QfbFypOjR0g1dWCEWAaJVUWDNmqnrmj+ym+hxNOVrqDl
        BeFbpbVvSQ5HPy0lgk2JPr4JQ/O+vzFeDO8CGhqql0pJOnibmC7ssv9EY9m8yV5nrmUb2K0nWPGtw
        XwmZrOemEST8OGG3oTr8PNbWuC27iHkmPwn5V3fWyqnzi//zFsZpLOaseEBglhPF+obo6Eq0pbMdL
        MOzlPx6Dl5Hq7vBaV04ApVKgGj6qzRKUkJrllJaDruoNrizOqZZPiCq/d72LXOv2vdu8zVmCDSXry
        gtEAUBYn3eLctN+IGhinJPGh;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1ojJaS-004EY7-B8
        for io-uring@vger.kernel.org; Fri, 14 Oct 2022 12:14:48 +0000
Message-ID: <63fb88fe-2e88-d9a0-fca4-3c8108b68abd@samba.org>
Date:   Fri, 14 Oct 2022 14:14:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US, de-DE
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring <io-uring@vger.kernel.org>
Subject: fast io_uring development using livepatching to test/debug simple
 changes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I'm used to do kernel hacking using kernel modules, which allows me to test things very fast.

When I do io_uring coding, I just want to build my own kernel just once
and debug/test fixes without the need to rebuild/reboot.

For that I have some patches, see
https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/io_uring_livepatch.v6.1

I include them in the kernel I build and then I'm able to do quick adjustments until
the feature I'm working on does what I want...

metze
