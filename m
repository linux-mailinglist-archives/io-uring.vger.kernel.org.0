Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E33FE133562
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2020 23:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgAGWBh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jan 2020 17:01:37 -0500
Received: from yourcmc.ru ([195.209.40.11]:34224 "EHLO yourcmc.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgAGWBh (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 7 Jan 2020 17:01:37 -0500
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jan 2020 17:01:36 EST
Received: from yourcmc.ru (localhost [127.0.0.1])
        by yourcmc.ru (Postfix) with ESMTP id CBEADFE0656
        for <io-uring@vger.kernel.org>; Wed,  8 Jan 2020 00:53:39 +0300 (MSK)
Received: from localhost (stump [176.62.179.109])
        by yourcmc.ru (Postfix) with ESMTPSA id 9F404FE00CB
        for <io-uring@vger.kernel.org>; Wed,  8 Jan 2020 00:53:39 +0300 (MSK)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To:     io-uring@vger.kernel.org
Date:   Wed, 08 Jan 2020 00:53:39 +0300
Subject: io_uring and TRIM?
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Vitaliy Filippov" <vitalif@yourcmc.ru>
Message-ID: <op.0d1lrpwy0ncgu9@localhost>
User-Agent: Opera Mail/12.16 (Linux)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi, do I understand it correctly that it's currently impossible to do TRIM  
with io_uring?

I've seen ioctl operation support patches but they were really recent.  
Will they allow TRIM? When can we expect to see them merged in the kernel?

// io_uring is really cool by the way, thanks for the work :)

-- 
With best regards,
   Vitaliy Filippov
