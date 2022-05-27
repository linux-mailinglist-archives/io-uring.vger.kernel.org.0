Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23AF536410
	for <lists+io-uring@lfdr.de>; Fri, 27 May 2022 16:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbiE0O3Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 May 2022 10:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbiE0O3Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 May 2022 10:29:24 -0400
Received: from USAT19PA25.eemsg.mail.mil (USAT19PA25.eemsg.mail.mil [214.24.22.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3796F12388A
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 07:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2021v1a;
  t=1653661762; x=1685197762;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=i02930sXU1EtfBW1MpKWnDShQRpx3ZfQtOdXvksbCvI=;
  b=VrX/PBGdDu8s/aa8qT7pbAHkBYRRs6NQwrHzhztPW8zps0zULiqaTujS
   8E9WjpSV9o2RY29/POABv5hAFIxhpU52UH2vmkzMbvC/CzbyRe5Y3jG58
   BI3rlqd2fuvAbFuoemDBh7ruuN1YjwgHdgZXaqM62XjrZIcKH6d7PndGI
   BRQzVliHTCZTF+BmaK6/x54R2UR89ajc4j4eHFnNRy5j4uzJ5okglLrjr
   OyAL0Wo/FB4zDLQTK9aQTQc+uMp74HeKA+pj4cPj0IRrEbI0eQ7UYNRrs
   UoUuxb0zqaRgPJqob2csTeZhyHFd2tOMpcEDJJpcvseC+k43igs99zrkb
   Q==;
X-EEMSG-check-017: 333644635|USAT19PA25_ESA_OUT06.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.91,255,1647302400"; 
   d="scan'208";a="333644635"
IronPort-Data: A9a23:/0WjjKt72yruCcry7xnHJG2gKufnVJVcMUV32f8akzHdYApBsoF/q
 tZmKW+COKrcYjb3ft5/Yd7i8kgP75WDndQyQFZp/383EipB9ZOVVN+UEBz9bniYRiHhoOOLz
 Cm8hv3odp1cokf0/0zrav69xZVF/fngqoDUUIYoAQgsA149IMsdoUg7wbRh39Q32YLR7z6l4
 bseneWOYDdJ5BYpagr424rbwP9elKyaVAEw5zTSVtgS1LPqrET5ObpETU2Hw9sUdaEPdgKyb
 76rILhUZQo19T91Yj+uuu6TnkHn3tfv0QayZnp+A8BOgzBPqiM/l6M2P/pEMAFSgjSN2dVwz
 L2ht7TqEFtvZPSKwb9FFUAAS0mSPoUfkFPDCXWivsGVwgvINWThyfh0UQc9PJMw/+92BSdL9
 PhwxDUlNUvY2b7qnunmIgVrroF5RCXxB6sevTR91zDfAt44Tp3ZBabH/9lV2HE3nM8mIBp0T
 6L1chJiYBvNJhhCMVdPUdQ7leaswHz+d1VlRJuujfJfywDuIMZZidAB7PK9lgS2ePho
IronPort-HdrOrdr: A9a23:H2Mo0Kya+zQdZrq6L5RgKrPwCr1zdoMgy1knxilNoH1uA7Slfq
 WV98jzuiWbtN98YhwdcJO7Scy9qArnlKKduLNwAV7AZniFhILLFvAa0WKK+VSJcREWndQz6U
 4PScRD4ZLLfDxHZGvBkW6FOsdl6uOutIqvgf7az39rRw0vUad99A10YzzrcXGeADM2Y6YEKA
 ==
Received: from edge-mech01.mail.mil ([214.21.130.100])
  by USAT19PA25.eemsg.mail.mil with ESMTP/TLS/ECDHE-RSA-AES256-SHA384; 27 May 2022 14:29:20 +0000
Received: from UMECHPAOI.easf.csd.disa.mil (214.21.130.36) by
 edge-mech01.mail.mil (214.21.130.100) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Fri, 27 May 2022 14:29:19 +0000
Received: from UMECHPA66.easf.csd.disa.mil ([169.254.8.113]) by
 umechpaoi.easf.csd.disa.mil ([1.213.132.154]) with mapi id 14.03.0513.000;
 Fri, 27 May 2022 14:29:19 +0000
From:   "Weber, Eugene F Jr CIV (USA)" <eugene.f.weber5.civ@mail.mil>
To:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Erroneous socket connect pass?
Thread-Topic: Erroneous socket connect pass?
Thread-Index: Adhx1ia4T2jTbCZGRESVYsEn7LQPqw==
Date:   Fri, 27 May 2022 14:29:19 +0000
Message-ID: <60DCCBD6DDA29F4A9EFF6DB52DEE2AB1D866F5D3@UMECHPA66.easf.csd.disa.mil>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [214.21.97.85]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

=0A=
Hi,=0A=
=0A=
Thanks for creating liburing. Great stuff.=0A=
=0A=
I **may** have found a bug. I would expect a socket connect using io_uring =
to fail as it does using connect() if the port is not setup to listen. In t=
he simple test case attached it does not. If this is pilot error, please le=
t me know what I'm doing wrong, or why my expectation is incorrect. Version=
 information is in the code header. Please let me know if any additional in=
formation is needed.=0A=
=0A=
Thanks,=0A=
=0A=
Gene=0A=
=0A=
=0A=
//=0A=
// Simple program to demonstrate erroneous connect pass.=0A=
//=0A=
// liburing Version: 2.2=0A=
// Linux 5.13.0-1025-aws #27~20.04.1-Ubuntu=0A=
// g++ (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0=0A=
// g++ -Wall -O3 -o cnct_test cnct_test.cpp -luring=0A=
//=0A=
#include <stdlib.h>=0A=
#include <arpa/inet.h>=0A=
#include <stdio.h>=0A=
#include <sys/socket.h>=0A=
#include <cstring>=0A=
#include <linux/time_types.h>=0A=
#include <liburing.h>=0A=
#define PORT 8080=0A=
#define ADDRESS "127.0.0.1"=0A=
=0A=
int main(int argc, char const* argv[]) {=0A=
    int sock =3D 0;=0A=
    struct sockaddr_in serv_addr;=0A=
    memset(&serv_addr, 0, sizeof(serv_addr));=0A=
=0A=
    if (argc !=3D 2) {=0A=
        fprintf(stderr, "\nUsage: %s test_number(1 or 2)\n\n", argv[0]);=0A=
        exit(EXIT_FAILURE);=0A=
    }=0A=
=0A=
    if ((sock =3D socket(AF_INET, SOCK_STREAM, 0)) < 0) {=0A=
        perror("Create socket failed");=0A=
        exit(EXIT_FAILURE);=0A=
    }=0A=
=0A=
    serv_addr.sin_family =3D AF_INET;=0A=
    serv_addr.sin_port =3D htons(PORT);=0A=
=0A=
    if (inet_pton(AF_INET, ADDRESS, &serv_addr.sin_addr) <=3D 0) {=0A=
        perror("Invalid address/ Address not supported");=0A=
        exit(EXIT_FAILURE);=0A=
    }=0A=
=0A=
    if (*argv[1] =3D=3D '1') {=0A=
        fprintf(stdout, "\nTesting that connect() fails if port isn't liste=
ning.\n");=0A=
        if (connect(sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr)) =
< 0) {=0A=
            perror("Connect failed");=0A=
            exit(EXIT_FAILURE);=0A=
        }=0A=
    }=0A=
=0A=
    if (*argv[1] =3D=3D '2') {=0A=
        fprintf(stdout, "\nTesting that connect using io_uring fails if por=
t isn't listening.\n");=0A=
        int job_info =3D 42; // The meaning of life.=0A=
        struct __kernel_timespec cnct_wait;=0A=
        cnct_wait.tv_sec =3D 15;=0A=
        struct io_uring_cqe *cqe;=0A=
=0A=
        struct io_uring io_uring_sq;=0A=
        int rtrn_val =3D io_uring_queue_init(256, &io_uring_sq, 0);=0A=
        if (rtrn_val < 0) {=0A=
            fprintf(stderr, "io_uring_queue_init failed: %d", -rtrn_val);=
=0A=
            exit (EXIT_FAILURE);=0A=
        }=0A=
        struct io_uring_sqe *sqe =3D io_uring_get_sqe(&io_uring_sq);=0A=
=0A=
        io_uring_prep_connect(sqe, sock, (struct sockaddr *) &serv_addr, si=
zeof(serv_addr));=0A=
        io_uring_sqe_set_data(sqe, &job_info);=0A=
=0A=
        rtrn_val =3D io_uring_submit(&io_uring_sq);=0A=
        if (rtrn_val < 0) {=0A=
            fprintf(stderr, "io_uring_submit failed: %d", -rtrn_val);=0A=
            exit (EXIT_FAILURE);=0A=
        }=0A=
=0A=
        rtrn_val =3D io_uring_wait_cqe_timeout(&io_uring_sq, &cqe, &cnct_wa=
it);=0A=
        //Same result: rtrn_val =3D io_uring_wait_cqe(&io_uring_sq, &cqe);=
=0A=
        if (rtrn_val < 0) {=0A=
            fprintf(stderr, "io_uring_wait_cqe failed: %d", -rtrn_val);=0A=
            exit (EXIT_FAILURE);=0A=
        }=0A=
        fprintf(stdout, "Why doesn't io_uring_wait_cqe_timeout fail or time=
out?\n\n");=0A=
    }=0A=
=0A=
    return 0;=0A=
}=0A=
=0A=
